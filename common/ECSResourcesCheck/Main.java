import java.io.IOException;

public class Main {

public static void main(String[] cluster) throws IOException {
    System.out.println(cluster[0]);
    Comparer comparer=new Comparer();
    comparer.compare(comparer.readJson(),cluster[0]);
}
}
