import com.amazonaws.services.ecs.model.ContainerDefinition;
import com.amazonaws.services.ecs.model.DescribeTaskDefinitionResult;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

public class TaskDefinitionParser {

    public JSONObject buildJson(DescribeTaskDefinitionResult service, int desiredCount) {
        JSONObject jsonObject = new JSONObject();
        List<ContainerDefinition> containerDefinitions = service.getTaskDefinition().getContainerDefinitions();

        // Main container
        ContainerDefinition mainContainer = containerDefinitions.get(0);
        String f = mainContainer.getEnvironment().toString();
        boolean rw = f.contains("DB_HOST_READER");

        jsonObject.put("CPUUnits", mainContainer.getCpu())
                .put("HardLimit", mainContainer.getMemory())
                .put("SoftLimit", mainContainer.getMemoryReservation())
                .put("Revision", service.getTaskDefinition().getRevision())
                .put("Version", mainContainer.getImage())
                .put("desiredCount", desiredCount)
                .put("RWSplitEnabled", rw)
                .put("Metaspace", getMetaspaceSize(f))
                .put("MaxMetaspaceSize", getMaxMetaspaceSize(f))
                .put("XMX", getXMX(f));

        // Sidecars
        JSONArray sidecars = new JSONArray();
        for (int i = 1; i < containerDefinitions.size(); i++) {
            ContainerDefinition sidecar = containerDefinitions.get(i);
            JSONObject sidecarJson = new JSONObject();
            String sidecarEnv = sidecar.getEnvironment().toString();
            sidecarJson.put("CPUUnits", sidecar.getCpu())
                    .put("HardLimit", sidecar.getMemory())
                    .put("SoftLimit", sidecar.getMemoryReservation())
                    .put("Version", sidecar.getImage())
                    .put("RWSplitEnabled", sidecarEnv.contains("DB_HOST_READER"))
                    .put("Metaspace", getMetaspaceSize(sidecarEnv))
                    .put("MaxMetaspaceSize", getMaxMetaspaceSize(sidecarEnv))
                    .put("XMX", getXMX(sidecarEnv));
            sidecars.put(sidecarJson);
        }
        jsonObject.put("sidecars", sidecars);

        return jsonObject;
    }

    public int getMetaspaceSize(String env) {
        if (env.contains("-XX:MetaspaceSize")) {
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
