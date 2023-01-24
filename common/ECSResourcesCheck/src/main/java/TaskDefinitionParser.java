import com.amazonaws.services.ecs.model.ContainerDefinition;
import com.amazonaws.services.ecs.model.DescribeTaskDefinitionResult;
import org.json.JSONObject;

public class TaskDefinitionParser {

    public JSONObject buildJson(DescribeTaskDefinitionResult service, int desiredCount) {
        JSONObject jsonObject = new JSONObject();
        ContainerDefinition containerDefinition = service.getTaskDefinition().getContainerDefinitions().get(0);
        String f = service.getTaskDefinition().getContainerDefinitions().get(0).getEnvironment().toString();
        boolean rw = false;
        if (f.contains("DB_HOST_READER")) {
            rw = true;
        }
        jsonObject.put("CPUUnits", containerDefinition.getCpu())
                .put("HardLimit", containerDefinition.getMemory())
                .put("SoftLimit", containerDefinition.getMemoryReservation())
                .put("Revision", service.getTaskDefinition().getRevision())
                .put("Version", containerDefinition.getImage())
                .put("desiredCount", desiredCount)
                .put("RWSplitEnabled", rw)
                .put("Metaspace", getMetaspaceSize(f))
                .put("MaxMetaspaceSize", getMaxMetaspaceSize(f))
                .put("XMX", getXMX(f));
        return jsonObject;
    }

    public int getMetaspaceSize(String env) {
        if (env.contains("MetaspaceSize")) {
            env = env.substring(env.indexOf("MetaspaceSize="));
            env = env.substring(env.indexOf("=") + 1, env.indexOf(" -XX") - 1);
            return Integer.parseInt(env);
        }
        return 0;
    }

    public int getMaxMetaspaceSize(String env) {
        if (env.contains("MaxMetaspaceSize")) {
            env = env.substring(env.indexOf("MaxMetaspaceSize="));
            env = env.substring(env.indexOf("=") + 1, env.indexOf(" "));
            if (env.toLowerCase().contains("m".toLowerCase())) {
                env = env.toLowerCase().replace("m", "");
            }
            return Integer.parseInt(env);
        }
        return 0;
    }

     public int getXMX(String env) {
        if (env.contains("-Xmx")) {
            env = env.substring(env.indexOf("-Xmx") + 4);
            env = env.substring(0, env.indexOf("m"));
            return Integer.parseInt(env);
        }
        return 0;
    }
}
