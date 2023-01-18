import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.ecs.AmazonECS;
import com.amazonaws.services.ecs.AmazonECSClientBuilder;
import com.amazonaws.services.ecs.model.*;
import org.json.JSONObject;

public class ECSResources {
    private AmazonECS _ecsClient;
    private String _cluster;

    public ECSResources ( String cluster, String aws_access_key_id, String aws_secret_access_key, String region){
        AWSCredentialsProvider credentialsProvider=new AWSStaticCredentialsProvider((new BasicAWSCredentials(aws_access_key_id, aws_secret_access_key)));
        _ecsClient= AmazonECSClientBuilder
                .standard()
                .withCredentials(credentialsProvider)
                .withRegion(region)
                .build();
        _cluster=cluster;
    }

    public ECSResources( AmazonECS ecsClient, String cluster){
        _ecsClient = ecsClient;
        _cluster=cluster;
    }

    public String describeService (String Service){
        DescribeServicesRequest describeServicesRequest=new DescribeServicesRequest();
        describeServicesRequest.setCluster(_cluster);
        describeServicesRequest.withServices(Service);
        DescribeServicesResult describeServicesResult =_ecsClient.describeServices(describeServicesRequest);
        if (describeServicesResult.getFailures().size()>0){
            return null;
        }
        return  describeServicesResult.getServices().get(0).getTaskDefinition();
    }

    public int getDesiredCount (String Service){
        DescribeServicesRequest describeServicesRequest=new DescribeServicesRequest();
        describeServicesRequest.setCluster(_cluster);
        describeServicesRequest.withServices(Service);
        DescribeServicesResult describeServicesResult =_ecsClient.describeServices(describeServicesRequest);
        return  describeServicesResult.getServices().get(0).getDesiredCount();
    }

    public JSONObject describeTaskDef(String service){
        String taskDefArn=describeService(service);
        if (taskDefArn==null){
            return null;
        }
        JSONObject jsonObject=new JSONObject();
        DescribeTaskDefinitionResult task=_ecsClient.describeTaskDefinition(new DescribeTaskDefinitionRequest().withTaskDefinition(taskDefArn));
        String f=task.getTaskDefinition().getContainerDefinitions().get(0).getEnvironment().toString();
     boolean rw=false;
        if(f.contains("DB_HOST_READER")){
            rw=true;
        }
        ContainerDefinition containerDefinition=task.getTaskDefinition().getContainerDefinitions().get(0);
        jsonObject.put("CPUUnits",containerDefinition.getCpu())
                .put("HardLimit",containerDefinition.getMemory())
                .put("SoftLimit",containerDefinition.getMemoryReservation())
                .put("Revision",task.getTaskDefinition().getRevision())
                .put("Version",containerDefinition.getImage())
                .put("desiredCount",getDesiredCount(service))
                .put("RWSplitEnabled",rw)
                .put("Metaspace",getMetaspaceSize(f))
                .put("MaxMetaspaceSize",getMaxMetaspaceSize(f))
                .put("XMX",getXMX(f));
        return jsonObject;
    }

    public int getMetaspaceSize (String env){
        if(env.contains("MetaspaceSize")) {
            env = env.substring(env.indexOf("MetaspaceSize="));
            env = env.substring(env.indexOf("=") + 1, env.indexOf(" -XX")-1);
            return Integer.parseInt(env);
        }
        return 0;
    }

    public int getMaxMetaspaceSize (String env){
        if(env.contains("MaxMetaspaceSize")){
            env=env.substring(env.indexOf("MaxMetaspaceSize="));
            env = env.substring(env.indexOf("=")+1,env.indexOf(" "));
            if (env.toLowerCase().contains("m".toLowerCase())){
                env=env.toLowerCase().replace("m","");
            }
            return Integer.parseInt(env);
        }
        return 0;
    }

    public int getXMX (String env){
        if(env.contains("-Xmx")){
           env=env.substring(env.indexOf("-Xmx")+4);
           env=env.substring(0,env.indexOf("m"));
            return Integer.parseInt(env);
        }
        return 0;
    }

}
