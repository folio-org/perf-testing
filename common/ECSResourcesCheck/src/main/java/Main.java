import org.json.JSONObject;

public class Main {
    public static void main(String[] args) {
        /*
            This is the main method where the program starts.
            args[0] = ecs cluster name,
            args[1] = aws_access_key_id,
            args[2] = aws_secret_access_key,
            args[3] = aws region,
            args[4] = base json with the list of modules
         */
        ECSServices ecsServices = new ECSServices(args[0], args[1], args[2], args[3]);
        Compare compare = new Compare(new JSONObject(args[4]), args[0], ecsServices);
    }
}
