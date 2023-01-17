import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import org.json.JSONObject;

public class Main {
    public static JSONObject readParam(String param){
        return new JSONObject(param);
    }

    public static void main(String[] args){
        System.out.println(args[0]);
        Comparer comparer=new Comparer();
        String json="";
        for (int i = 1; i <args.length ; i++) {
            json=json.concat(args[i]);

        }
        comparer.compare(readParam(json),args[0]);
    }
}
