import org.json.JSONObject;
public class Comparer {

    public void compare(final JSONObject jsonBase, final String clusterName, final ECSResources ecs) {
        Object[] arr = jsonBase.keySet().toArray();
        JSONObject output = new JSONObject();
        int key = jsonBase.keySet().toArray().length;
        for (int i = 0; i < key; i++) {
            String module = arr[i].toString();
            System.out.println(module);
            JSONObject base = jsonBase.getJSONObject(module);
            JSONObject target = ecs.describeTaskDef(module);
            if (target != null) {
                checkDifferences(target, base, clusterName);
                output.accumulate(module, checkDifferences(target, base, clusterName));
            }
            else {
                System.out.println("there is no such module in cluster " + clusterName);
                output.accumulate(module, "no such module");
            }
        }
        System.out.println(output);
    }
    public JSONObject checkDifferences(final JSONObject target, final JSONObject base, final String clusterName) {
        JSONObject output = new JSONObject();
            if (base.toString().equals(target.toString())) {
                return null;
            } else {
                if (base.getInt("SoftLimit") != target.getInt("SoftLimit")) {
                    output.put("SoftLimit-cluster-" + clusterName, target.getInt("SoftLimit"));
                    output.put("SoftLimit-input", base.getInt("SoftLimit"));
                }
                if (base.getInt("XMX") != target.getInt("XMX")) {
                    output.put("XMX-cluster-" + clusterName, target.getInt("XMX"));
                    output.put("XMX-input", base.getInt("XMX"));
                }
                if (!base.getString("Version").equals(target.getString("Version"))) {
                    output.put("Version-cluster-" + clusterName, target.getString("Version"));
                    output.put("Version-input", base.getString("Version"));
                }
                if (base.getInt("desiredCount") != target.getInt("desiredCount")) {
                    output.put("desiredCount-cluster-" + clusterName, target.getInt("desiredCount"));
                    output.put("desiredCount-input", base.getInt("desiredCount"));
                }
                if (base.getInt("CPUUnits") != target.getInt("CPUUnits")) {
                    output.put("CPUUnits-cluster-" + clusterName, target.getInt("CPUUnits"));
                    output.put("CPUUnits-input", base.getInt("CPUUnits"));
                }
                if (base.getBoolean("RWSplitEnabled") != target.getBoolean("RWSplitEnabled")) {
                    output.put("RWSplitEnabled-cluster-" + clusterName, target.getBoolean("RWSplitEnabled"));
                    output.put("RWSplitEnabled-input", base.getBoolean("RWSplitEnabled"));
                }
                if (base.getInt("HardLimit") != target.getInt("HardLimit")) {
                    output.put("HardLimit-cluster-" + clusterName, target.getInt("HardLimit"));
                    output.put("HardLimit-input", base.getInt("HardLimit"));
                }
                if (base.getInt("Metaspace") != target.getInt("Metaspace")) {
                    output.put("Metaspace-cluster-" + clusterName, target.getInt("Metaspace"));
                    output.put("Metaspace-input", base.getInt("Metaspace"));
                }
                if (base.getInt("MaxMetaspaceSize") != target.getInt("MaxMetaspaceSize")) {
                    output.put("MaxMetaspaceSize-cluster-" + clusterName, target.getInt("MaxMetaspaceSize"));
                    output.put("MaxMetaspaceSize-input", base.getInt("MaxMetaspaceSize"));
                }
            }
        return output;
    }
    }

