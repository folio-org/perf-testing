import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;

public class Writer {
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
                "        <th class=\"tg-73oq\">Revision</th>\n" +
                "        <th class=\"tg-73oq\">Version</th>\n" +
                "        <th class=\"tg-73oq\">Count</th>\n" +
                "        <th class=\"tg-73oq\"><span style=\"font-weight:400;font-style:normal\">Hard LImit</span></th>\n" +
                "        <th class=\"tg-73oq\"><span style=\"font-weight:400;font-style:normal\">Soft limit</span></th>\n" +
                "        <th class=\"tg-73oq\">CPU units</th>\n" +
                "        <th class=\"tg-73oq\">xmx</th>\n" +
                "        <th class=\"tg-73oq\">metaspace</th>\n" +
                "        <th class=\"tg-73oq\">maxMetaspace</th>\n" +
                "        <th class=\"tg-73oq\">R/W split enabled</th>\n" +
                "    </tr>\n" +
                "    </thead>\n" +
                "    <tbody>";
        BufferedWriter writer = new BufferedWriter(new FileWriter("clusterResources.html"));
        writer.write(Head);
        for (int i = 0; i < json.length(); i++) {
            JSONArray a=json.names();

            JSONObject aa= json.getJSONObject(a.get(i).toString());//really?

            String s = "<tr>\n" +
                    "        <td class=\"tg-73oq\">"+a.get(i).toString()+"<br></td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("Revision")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getString("Version")+"<br></td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("desiredCount")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("HardLimit")+"<br></td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("SoftLimit")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("CPUUnits")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("XMX")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("Metaspace")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getInt("MaxMetaspaceSize")+"</td>\n" +
                    "        <td class=\"tg-73oq\">"+aa.getBoolean("RWSplitEnabled")+" </td>\n" +
                    "    </tr>";
            writer.append(s);
        }
        String footer =" </tbody>\n" +
                "</table>";


        writer.append(footer);
        writer.close();
    }


}
