import com.amazonaws.services.ecs.model.DescribeTaskDefinitionResult;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class Main {
    public static void main(String[] args) throws IOException {
        /*
            This is the main method where the program starts.
            args[0] = ecs cluster name,
            args[1] = aws_access_key_id,
            args[2] = aws_secret_access_key,
            args[3] = aws region,
            args[4] = behavior[get description of services,       TBD:::compare cluster between each other, compare cluster with json],
            args[5] = coma separated values of values
            args[6] = base json with the list of modules
         */
       Date date = Calendar.getInstance().getTime();

        if (args[4].equals("get")) {
            Writer writer = new Writer();
            JSONObject json = new JSONObject();
            ECSServices ecsServices = new ECSServices(
                    args[0], //ecs cluster name
                    args[1], //aws_access_key_id,
                    args[2], //aws_secret_access_key,
                    args[3]);  //aws region

            if (args[5].equals("null")) {
                System.out.println("it's getting cluster info");
                json = ecsServices.getServiceslist();
                writer.write(json, date, args[0]);
            }

            else {
                System.out.println("I'm retrieving list of modules");
                List<String> modules = Arrays.asList(args[5].split(","));
                TaskDefinitionParser taskDefinitionParser = new TaskDefinitionParser();
                for (int i = 0; i < modules.size(); i++) {
                    DescribeTaskDefinitionResult taskDefinitionResult = ecsServices.describeTaskDef(modules.get(i));
                    json.put(modules.get(i), taskDefinitionParser.buildJson(taskDefinitionResult, ecsServices.getDesiredCount(modules.get(i))));
                    writer.write(json, date, args[0]);
                }
                System.out.println(json);

            }
        }

        if (args[4].equals("null")) {
            ECSServices ecsServices = new ECSServices(args[0], args[1], args[2], args[3]);
            Compare compare = new Compare(new JSONObject(args[6]), args[0], ecsServices);
        }
    }
}
