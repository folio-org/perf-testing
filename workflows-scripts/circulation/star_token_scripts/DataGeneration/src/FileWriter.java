import java.io.BufferedWriter;
import java.io.IOException;

public class FileWriter {
    public void write() throws IOException {
        RecordCreator recordCreator = new RecordCreator();
        BufferedWriter writer = new BufferedWriter(new java.io.FileWriter("requests.tsv"));
        BufferedWriter writerIDO = new BufferedWriter(new java.io.FileWriter("IDToUseOpen.txt"));
        BufferedWriter writerIDC = new BufferedWriter(new java.io.FileWriter("IDToUseClosed.txt"));
        BufferedWriter writeLoan = new BufferedWriter(new java.io.FileWriter("loans.tsv"));
        writerIDO.write("ID,ItemID,requester,pickPoint");
        writerIDO.newLine();
        writerIDC.write("ID,ItemID,requester,pickPoint");
        writerIDC.newLine();
        for (int i = 0; i < 5000; i++) {
            String ID = recordCreator.UUIDCreator();
            String LoanID = recordCreator.UUIDCreator();
            String itemID = recordCreator.ItemIdCreator();
            String requester = recordCreator.UUIDCreator();
            String PickPoint = recordCreator.UUIDCreator();

            writer.write(recordCreator.DataCretion(recordCreator.StatusOpen, ID, itemID, requester, PickPoint));
            writerIDO.write(ID + "," + itemID + "," + requester + "," + PickPoint);
            writer.newLine();
            writerIDO.newLine();
            writeLoan.write(recordCreator.LoanCreator(LoanID, itemID, PickPoint, "Open"));
            writeLoan.newLine();
        }
        for (int i = 0; i < 15000; i++) {
            String ID = recordCreator.UUIDCreator();
            String LoanID = recordCreator.UUIDCreator();
            String itemID = recordCreator.ItemIdCreator();
            String requester = recordCreator.UUIDCreator();
            String PickPoint = recordCreator.UUIDCreator();

            writer.write(recordCreator.DataCretion(recordCreator.StatusClosed, ID, itemID, requester, PickPoint));
            writerIDC.write(ID + "," + itemID + "," + requester + "," + PickPoint);
            writer.newLine();
            writerIDC.newLine();
            writeLoan.write(recordCreator.LoanCreator(LoanID, itemID, PickPoint, "Closed"));
            writeLoan.newLine();
        }

        writer.close();
        writerIDO.close();
        writerIDC.close();
        writeLoan.close();
    }
}
