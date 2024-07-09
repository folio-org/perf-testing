import com.amazonaws.services.ecs.model.DescribeTaskDefinitionResult;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class Main {
    public static void main(String[] args) throws IOException {
        System.out.println("Hello");
        /*
            This is the main method where the program starts.
            args[0] = ecs cluster name,
            args[1] = aws_access_key_id,
            args[2] = aws_secret_access_key,
            args[3] = aws_session_token,
            args[4] = aws region,
            args[5] = behavior[get description of services,       TBD:::compare cluster between each other, compare cluster with json],
            args[6] = coma separated values of values
            args[7] = base json with the list of modules
         */
        Date date = Calendar.getInstance().getTime();

        if (args[5].equals("get")) {
            ServicesConfigHtmlWriter servicesConfigHtmlWriter = new ServicesConfigHtmlWriter();
            JSONObject json = new JSONObject();
            ECSServices ecsServices = new ECSServices(
                    args[0], // ecs cluster name
                    args[1], // aws_access_key_id
                    args[2], // aws_secret_access_key
                    args[3], // aws_session_token
                    args[4]  // aws region
            );

            if (args[6].equals("null")) {
                System.out.println("It's getting cluster info");
                json = ecsServices.getServiceslist();
                servicesConfigHtmlWriter.write(json, date, args[0]);
            } else {
                System.out.println("I'm retrieving list of modules");
                List<String> modules = Arrays.asList(args[6].split(","));
                TaskDefinitionParser taskDefinitionParser = new TaskDefinitionParser();
                for (String module : modules) {
                    DescribeTaskDefinitionResult taskDefinitionResult = ecsServices.describeTaskDef(module);
                    json.put(module, taskDefinitionParser.buildJson(taskDefinitionResult, ecsServices.getDesiredCount(module)));
                    servicesConfigHtmlWriter.write(json, date, args[0]);
                }
                System.out.println(json);
            }
        }

        if (args[5].equals("null")) {
            ECSServices ecsServices = new ECSServices(
                    args[0], // ecs cluster name
                    args[1], // aws_access_key_id
                    args[2], // aws_secret_access_key
                    args[3], // aws_session_token
                    args[4]  // aws region
            );
            Compare compare = new Compare(new JSONObject(args[7]), args[0], ecsServices);
        }
    }
}
