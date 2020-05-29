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

#Sql queries to get jmeter-supported-data
- user_barcodes.csv <br/>
`SELECT CONCAT(id,'.', jsonb->>'barcode') FROM fs09000000_mod_users.users WHERE jsonb->>'barcode' != ''`

- holdings_instances_barcodes.csv <br/>
`select RH.jsonb->>'instanceId' as InstanceID, I.jsonb->>'holdingsRecordId' as HoldingsRecordID, I.jsonb->>'barcode' as Barcode from fs09000000_mod_inventory_storage.item as I inner join fs09000000_mod_inventory_storage.holdings_record as RH ON I.jsonb->>'holdingsRecordId' = RH.jsonb->>'id' group by I.jsonb->>'holdingsRecordId', RH.jsonb->>'instanceId', I.jsonb->>'barcode'`