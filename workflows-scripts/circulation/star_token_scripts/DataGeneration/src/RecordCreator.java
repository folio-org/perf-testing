import java.util.UUID;

public class RecordCreator {

    public String StatusOpen="Open - Not yet filled";
    public String StatusClosed="Closed - Filled";
    public int neededOpen=5000;
    public int neededClosed=15000;

    public String DataCretion(String Status,String ID,String itemID,String requester, String PickPoint ){
        String Final;
        String midle2="\"item\": {\"title\": \"The Journal of surgical research.\", \"barcode\": \"52100999\", \"identifiers\": [{\"value\": \"0022-4804\", \"identifierTypeId\": \"2b9f4284-e836-43a1-9aa9-a4c8c2be38d3\"}, {\"value\": \"(ICU)BID3672743\", \"identifierTypeId\": \"2baf4cec-6abf-438b-abd0-a6c512c3c173\"}, {\"value\": \"(OCoLC)1783129\", \"identifierTypeId\": \"01ca9cda-7027-4d64-abed-9e3c4943daf2\"}]}, \"itemId\": \"";
        String end ="\", \"metadata\": {\"createdDate\": \"2020-05-12T03:09:00.287\", \"updatedDate\": \"2020-05-12T03:09:00.287+0000\", \"createdByUserId\": \"9a4e9b21-8404-437e-abb2-76998218ab73\", \"updatedByUserId\": \"9a4e9b21-8404-437e-abb2-76998218ab73\"}, \"position\": 1, \"requester\": {\"barcode\": \"0000030261\", \"lastName\": \"Kolodziej\", \"firstName\": \"Amanda\", \"middleName\": \"K\"}, \"requestDate\": \"2020-05-12T03:08:47.524+0000\", \"requestType\": \"Recall\", \"requesterId\": \"";
        String middle3=requester+"\", \"fulfilmentPreference\": \"Hold Shelf\", \"pickupServicePointId\": \""+PickPoint+"\"}";
        Final=(ID+"\t"+"{\"id\": \""+ID+"\", "+midle2+itemID+"\", \"status\": \""+Status+end+middle3);

        return Final;
    }
    public String LoanCreator(String ID,String ItemID,String CheckPoint,String Status){
        String Final;
        String FirstPart=ID+"\t{\"id\": \""+ID+"\", \"action\": \"checkedout\", \"itemId\": \""+ItemID;
        String SecondPart="\", \"status\": {\"name\": \"";



        return FirstPart+SecondPart+Status+"\"}, \"userId\": \"e1f39836-715a-4530-a03b-3cb3af0299af\", \"dueDate\": \"2019-09-06T07:22:30.000+0000\", \"loanDate\": \"2020-05-11T23:08:27.297068+0000\", \"metadata\": {\"createdDate\": \"2020-05-11T23:08:30.31\", \"updatedDate\": \"2020-05-11T23:08:30.802+0000\", \"createdByUserId\": \"9a4e9b21-8404-437e-abb2-76998218ab73\", \"updatedByUserId\": \"9a4e9b21-8404-437e-abb2-76998218ab73\"}, \"itemStatus\": \"Checked out\", \"loanPolicyId\": \"2be97fb5-eb89-46b3-a8b4-776cea57a99e\", \"lostItemPolicyId\": \"6699ab75-d639-4dd4-9a82-b3ab0ffffd0a\", \"overdueFinePolicyId\": \"0f8193f2-8338-4def-b53d-893acaa6f20a\", \"checkoutServicePointId\": \"7068e104-aa14-4f30-a8bf-71f71cc15e07\", \"patronGroupIdAtCheckout\": \"648ec9f2-c292-4e74-932b-9e5cf059d4d6\"}";
    }
    public String UUIDCreator(){
        UUID ID= UUID.randomUUID();
        return ID.toString();
    }
    public String ItemIdCreator(){
        UUID ItemID=UUID.randomUUID();
        return ItemID.toString();
    }
}
