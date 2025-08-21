import java.util.ArrayList;
import java.util.List;

public class MemoryLeakSimulator {

    // Global static list that holds data and never releases it
    private static final List<byte[]> memoryLeakList = new ArrayList<>();

    public static void main(String[] args) throws InterruptedException {
        System.out.println("Starting memory leak simulation...");

        int iteration = 0;
        while (true) {
            // Allocate 10MB chunk and hold it forever
            byte[] block = new byte[10 * 1024 * 1024]; // 10 MB
            memoryLeakList.add(block);

            iteration++;
            System.out.println("Allocated " + (iteration * 10) + " MB so far.");

            // Pause for visibility and to avoid instant OOM
            Thread.sleep(1000);
        }
    }
}
