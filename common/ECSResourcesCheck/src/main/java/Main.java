import org.json.JSONObject;

public class Main {
    public static JSONObject readParam(String param){
        return new JSONObject(param);
    }

    public static void main(String[] args){
        Comparer comparer=new Comparer();
        ECSResources ecs=new ECSResources(args[0],args[1],args[2], args[3]);
        comparer.compare(readParam(args[4]),args[0],ecs);}


    }
