import java.io.IOException;
import java.net.URISyntaxException;

public class Main {
    public static void main(String[] args){
        System.out.println(args[0]);
        Comparer comparer=new Comparer();
        String json="";
        for (int i = 1; i <args.length ; i++) {
            json=json.concat(args[i]);

        }
        comparer.compare(comparer.readParam(json),args[0]);
    }
}
