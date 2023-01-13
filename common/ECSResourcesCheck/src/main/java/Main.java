import java.io.IOException;
import java.net.URISyntaxException;

public class Main {
    public static void main(String[] cluster) throws IOException {
        System.out.println(cluster[0]);
        Comparer comparer=new Comparer();
        try {
            comparer.compare(comparer.readJson(),cluster[0]);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }
}
