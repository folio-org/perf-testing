import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.ecs.AmazonECS;
import com.amazonaws.services.ecs.AmazonECSClientBuilder;
import com.amazonaws.services.ecs.model.DescribeServicesRequest;
import com.amazonaws.services.ecs.model.DescribeServicesResult;
import com.amazonaws.services.ecs.model.DescribeTaskDefinitionRequest;
import com.amazonaws.services.ecs.model.DescribeTaskDefinitionResult;

public class ECSServices {
    public AmazonECS _ecsClient;
    public String _cluster;

    public ECSServices(String cluster, String aws_access_key_id, String aws_secret_access_key, String region) {
        AWSCredentialsProvider credentialsProvider = new AWSStaticCredentialsProvider((new BasicAWSCredentials(aws_access_key_id, aws_secret_access_key)));
        _ecsClient = AmazonECSClientBuilder
                .standard()
                .withCredentials(credentialsProvider)
                .withRegion(region)
                .build();
        _cluster = cluster;
    }

    public ECSServices(AmazonECS ecsClient, String cluster) {
        _ecsClient = ecsClient;
        _cluster = cluster;
    }

    public String describeService(String Service) {
        DescribeServicesRequest describeServicesRequest = new DescribeServicesRequest();
        describeServicesRequest.setCluster(_cluster);
        describeServicesRequest.withServices(Service);
        DescribeServicesResult describeServicesResult = _ecsClient.describeServices(describeServicesRequest);
        if (describeServicesResult.getFailures().size() > 0) {
            return null;
        }
        return  describeServicesResult.getServices().get(0).getTaskDefinition();
    }

    public int getDesiredCount(String Service) {
        DescribeServicesRequest describeServicesRequest = new DescribeServicesRequest();
        describeServicesRequest.setCluster(_cluster);
        describeServicesRequest.withServices(Service);
        DescribeServicesResult describeServicesResult = _ecsClient.describeServices(describeServicesRequest);
        if (describeServicesResult.getFailures().size() > 0) {
            return 0;
        }
        return  describeServicesResult.getServices().get(0).getDesiredCount();
    }

    public DescribeTaskDefinitionResult describeTaskDef(String service) {
        String taskDefArn = describeService(service);
        if (taskDefArn != null) {
        return _ecsClient.describeTaskDefinition(new DescribeTaskDefinitionRequest().withTaskDefinition(taskDefArn));
        }
        return null;
    }
}
