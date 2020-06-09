## Workflow steps:
### Pre-requisite:
1. Open Inventory App
2. Select Instance tab in top left
3. Select Keyword(title, contributor, identifier) in the drop down and type "aba" in search field


## Workflow steps:
##### Workflow for inventory_loadItems.jmx
1. Select the third instance "ABA 7th National Conference on Law Office Economics 
and Management[sponsored by] Section of Economics of Law Practice, American Bar Association."
2. Check that items from Holding section have "Available" or "In transit" status 
3. Copy one of the item barcodes in the Holding section
4. Go to Checkout page
5. Open "Patron look-up" modal window
6. Select an active user with a barcode and close "Patron look-up" modal window
7. Put the item barcode to "Scan or enter item barcode" field
8. Click "Enter" button 
9. Return to "Inventory app"
10. Wait until all items records appear in the Holdings section


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-19.1.2
- mod-inventory-14.1.3
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.38.0
##### Frontend:
- folio_inventory-2.0.2

- FOLIO release: FameFlower

#Sql queries from jmeter-supported-data folder
- user_barcodes.csv <br/>
`psql -h pre-items-status-update-3-24-20-from-live.c5cqgppfbl8c.us-east-1.rds.amazonaws.com -d folio -U folio -t -A -F"," -c "SELECT CONCAT(id,'.', jsonb->>'barcode') FROM fs09000000_mod_users.users WHERE jsonb->>'barcode' != '';" > 'users.csv'
`
- holdings_instances_barcodes.csv <br/>
`psql -h pre-items-status-update-3-24-20-from-live.c5cqgppfbl8c.us-east-1.rds.amazonaws.com -d folio -U folio -t -A -F"," -c "select RH.jsonb->>'instanceId' as InstanceID, I.jsonb->>'holdingsRecordId' as HoldingsRecordID, I.jsonb->>'barcode' as Barcode from fs09000000_mod_inventory_storage.item as I inner join fs09000000_mod_inventory_storage.holdings_record as RH ON I.jsonb->>'holdingsRecordId' = RH.jsonb->>'id' group by I.jsonb->>'holdingsRecordId', RH.jsonb->>'instanceId', I.jsonb->>'barcode';" > 'holdings_instances_barcodes.csv'
`
- service_points.csv <br/>
they are received on UI

###How the JMeter script works? </br>
JMeter simulates a group of users sending requests from the loading items workflow to a target server, 
and returns statistics that show the performance of the target server via View Results Tree and Aggregate Report

The script includes several csv data config files and 2 thread groups: </br>
###### Csv data config files 
They are used for test parameterization, for creating different data sets for different users in the same test script.
- credentials.csv (contains username,password,tenant, they are needed for login)
- holdings_instances_barcodes.csv (contains instance id,holdings record id and item barcode.
     InstanceID,holdingsRecordId are needed to get instance, holding record and some related data)
- service_points.csv (contains service point id, it is used to get requests, items and check out an item )
- users.csv (contains userId,userBarcode, they are used for check-out sub-workflow)

###### Thread groups (a thread group - a set of threads executing the same scenario):
 - Login - for identification and authentication, it is executed only 1 time
 - Loading items on instance record - the workflow which is tested, 
 the user defined variables defines how the workflow will be executed
 
 #### The loading items on instance record thread group contains:
 - Transaction controller "Loading items on instance record" - the workflow for loading items 
 - Check-in request - it is an "item's cleaning", need to change item's status in order to an item can be checked out
 
 ##### Transaction controller "Loading items on instance record"
 This is a simplified workflow (see #Workflow steps), the whole workflow can be found in the attached screencast 
  https://issues.folio.org/browse/PERF-40

 The transaction controller contains a batch of endpoints for Loading items on instance record which are logically divided into 3 module controllers (depends on App on UI: Inventory -> Checkout->Inventory):
 
 - Find an instance - a list of endpoints to find an instance
 - Check-out - a list of endpoints to checkout
 - Load items - a list of endpoints to load items on instance record (in holdings accordion)