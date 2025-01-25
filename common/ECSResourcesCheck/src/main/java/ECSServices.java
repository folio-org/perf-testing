import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicSessionCredentials;
import com.amazonaws.services.ecs.AmazonECS;
import com.amazonaws.services.ecs.AmazonECSClientBuilder;
import com.amazonaws.services.ecs.model.*;
import org.json.JSONObject;

import java.util.List;

public class ECSServices {
    private AmazonECS _ecsClient;
    private String _cluster;

    public ECSServices(String cluster, String aws_access_key_id, String aws_secret_access_key, String aws_session_token, String region) {
        // Create session credentials
        BasicSessionCredentials sessionCredentials = new BasicSessionCredentials(
                aws_access_key_id,
                aws_secret_access_key,
                aws_session_token
        );

        // Create a credentials provider
        AWSCredentialsProvider credentialsProvider = new AWSStaticCredentialsProvider(sessionCredentials);

        // Create the ECS client with the credentials provider
        _ecsClient = AmazonECSClientBuilder
                .standard()
                .withCredentials(credentialsProvider)
                .withRegion(region)
                .build();

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
        return describeServicesResult.getServices().get(0).getTaskDefinition();
    }

    public int getDesiredCount(String Service) {
        DescribeServicesRequest describeServicesRequest = new DescribeServicesRequest();
        describeServicesRequest.setCluster(_cluster);
        describeServicesRequest.withServices(Service);
        DescribeServicesResult describeServicesResult = _ecsClient.describeServices(describeServicesRequest);
        if (describeServicesResult.getFailures().size() > 0) {
            return 0;
        }
        return describeServicesResult.getServices().get(0).getDesiredCount();
    }

    public DescribeTaskDefinitionResult describeTaskDef(String service) {
        String taskDefArn = describeService(service);
        if (taskDefArn != null) {
            return _ecsClient.describeTaskDefinition(new DescribeTaskDefinitionRequest().withTaskDefinition(taskDefArn));
        }
        return null;
    }

    public JSONObject getServiceslist() {
        ListServicesRequest listServicesRequest = new ListServicesRequest().withCluster(_cluster);
        listServicesRequest.setMaxResults(100);
        ListServicesResult listServicesResult = _ecsClient.listServices(listServicesRequest);
        List<String> serviceArns = listServicesResult.getServiceArns();
        int size = serviceArns.size();
        TaskDefinitionParser taskDefinitionParser = new TaskDefinitionParser();
        JSONObject json = new JSONObject();
        for (int i = 0; i < size; i++) {
            DescribeTaskDefinitionResult task = describeTaskDef(serviceArns.get(i));
            json.put(task.getTaskDefinition().getContainerDefinitions().get(0).getName(),
                    taskDefinitionParser.buildJson(task, getDesiredCount(serviceArns.get(i))));
        }
        return json;
    }
}
