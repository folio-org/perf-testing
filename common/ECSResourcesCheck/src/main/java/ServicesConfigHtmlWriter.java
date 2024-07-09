import org.json.JSONArray;
import org.json.JSONObject;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Date;

public class ServicesConfigHtmlWriter {

    public void write(JSONObject json, Date date, String cluster) throws IOException {
        String html = generateHtml(json, date, cluster);
        writeToFile(html);
    }

    private String generateHtml(JSONObject json, Date date, String cluster) {
        StringBuilder sb = new StringBuilder();

        sb.append("<html>\n<head>\n<style type=\"text/css\">\n");
        sb.append(".tg  {border-collapse:collapse;border-spacing:0;margin:auto;}\n");
        sb.append(".tg td{border-color:#ccc;border-style:solid;border-width:1px;color:#333;font-family:Arial, sans-serif;font-size:14px;padding:12px 8px;word-break:normal;}\n");
        sb.append(".tg th{background-color:#f0f0f0;border-color:#ccc;border-style:solid;border-width:1px;color:#333;font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:12px 8px;word-break:normal;}\n");
        sb.append(".tg .tg-73oq{text-align:left;vertical-align:top}\n");
        sb.append("</style>\n</head>\n");

        sb.append("<body style=\"font-family: Arial, sans-serif;\">\n");
        sb.append("<h2 style=\"text-align: center;\">Cluster Resources - ").append(cluster).append(" (").append(date).append(")</h2>\n");
        sb.append("<table class=\"tg\">\n<thead>\n<tr>\n");
        sb.append("<th class=\"tg-73oq\">Module</th>\n");
        sb.append("<th class=\"tg-73oq\">Task Definition Revision</th>\n");
        sb.append("<th class=\"tg-73oq\">Module Version</th>\n");
        sb.append("<th class=\"tg-73oq\">Task Count</th>\n");
        sb.append("<th class=\"tg-73oq\">Mem Hard Limit</th>\n");
        sb.append("<th class=\"tg-73oq\">Mem Soft Limit</th>\n");
        sb.append("<th class=\"tg-73oq\">CPU Units</th>\n");
        sb.append("<th class=\"tg-73oq\">Xmx</th>\n");
        sb.append("<th class=\"tg-73oq\">Metaspace Size</th>\n");
        sb.append("<th class=\"tg-73oq\">Max Metaspace Size</th>\n");
        sb.append("<th class=\"tg-73oq\">R/W Split Enabled</th>\n");
        sb.append("</tr>\n</thead>\n<tbody>\n");

        for (String moduleName : json.keySet()) {
            JSONObject moduleData = json.getJSONObject(moduleName);
            sb.append("<tr>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleName).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("Revision")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getString("Version")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("desiredCount")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("HardLimit")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("SoftLimit")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("CPUUnits")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("XMX")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("Metaspace")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getInt("MaxMetaspaceSize")).append("</td>\n");
            sb.append("<td class=\"tg-73oq\">").append(moduleData.getBoolean("RWSplitEnabled")).append("</td>\n");
            sb.append("</tr>\n");

            // Add sidecars
            if (moduleData.has("sidecars")) {
                JSONArray sidecars = moduleData.getJSONArray("sidecars");
                for (int i = 0; i < sidecars.length(); i++) {
                    JSONObject sidecar = sidecars.getJSONObject(i);
                    sb.append("<tr>\n");
                    sb.append("<td class=\"tg-73oq\">").append(moduleName).append(" - Sidecar ").append(i + 1).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append("N/A").append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getString("Version")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append("N/A").append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getInt("HardLimit")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getInt("SoftLimit")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getInt("CPUUnits")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getInt("XMX")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getInt("Metaspace")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getInt("MaxMetaspaceSize")).append("</td>\n");
                    sb.append("<td class=\"tg-73oq\">").append(sidecar.getBoolean("RWSplitEnabled")).append("</td>\n");
                    sb.append("</tr>\n");
                }
            }
        }

        sb.append("</tbody>\n</table>\n</body>\n</html>");
        return sb.toString();
    }

    private void writeToFile(String html) throws IOException {
        BufferedWriter writer = Files.newBufferedWriter(Paths.get("clusterResources.html"));
        writer.write(html);
        writer.close();
    }
}
