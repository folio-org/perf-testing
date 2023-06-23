import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;

public class ServicesConfigHtmlWriter {
    public void write(JSONObject json, Date date, String cluster)
            throws IOException {
        String Head = "<style type=\"text/css\">\n" +
                ".tg  {border-collapse:collapse;border-color:#ccc;border-spacing:0;}\n" +
                ".tg td{background-color:#fff;border-color:#ccc;border-style:solid;border-width:0px;color:#333;\n" +
                "  font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 3px;word-break:normal;}\n" +
                ".tg th{background-color:#f0f0f0;border-color:#ccc;border-style:solid;border-width:0px;color:#333;\n" +
                "  font-family:Arial, sans-serif;font-size:14px;font-weight:normal;overflow:hidden;padding:10px 3px;word-break:normal;}\n" +
                ".tg .tg-73oq{border-color:#000000;text-align:left;vertical-align:top}\n" +
                "</style>\n" +
                "<table class=\"tg\">\n" +
                "    <thead>\n" +
                "    <tr>\n" +
                "        <th class=\"tg-73oq\">Module<br>"+cluster+"<br>  "+date+"</th>\n" +
                "        <th class=\"tg-73oq\">Task Def. Revision</th>\n" +
                "        <th class=\"tg-73oq\">Module Version</th>\n" +
                "        <th class=\"tg-73oq\">Task Count</th>\n" +
                "        <th class=\"tg-73oq\"><span style=\"font-weight:400;font-style:normal\">Mem Hard Limit</span></th>\n" +
                "        <th class=\"tg-73oq\"><span style=\"font-weight:400;font-style:normal\">Mem Soft limit</span></th>\n" +
                "        <th class=\"tg-73oq\">CPU units</th>\n" +
                "        <th class=\"tg-73oq\">Xmx</th>\n" +
                "        <th class=\"tg-73oq\">MetaspaceSize</th>\n" +
                "        <th class=\"tg-73oq\">MaxMetaspaceSize</th>\n" +
                "        <th class=\"tg-73oq\">R/W split enabled</th>\n" +
                "    </tr>\n" +
                "    </thead>\n" +
                "    <tbody>";
        BufferedWriter writer = new BufferedWriter(new FileWriter("clusterResources.html"));
        writer.write(Head);
        for (int i = 0; i < json.length(); i++) {
            JSONArray names=json.names();
            JSONObject taskDef= json.getJSONObject(names.get(i).toString());
            String data = "<tr>\n" +
                    "        <td class=\"tg-73oq\">"+names.get(i).toString()+"<br></td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("Revision")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getString("Version")+"<br></td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("desiredCount")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("HardLimit")+"<br></td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("SoftLimit")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("CPUUnits")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("XMX")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("Metaspace")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getInt("MaxMetaspaceSize")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+taskDef.getBoolean("RWSplitEnabled")+" </td>\n" +
                    "    </tr>";
            writer.append(data);
        }
        String footer =" </tbody>\n" +"</table>";
        writer.append(footer);
        writer.close();
    }
}
