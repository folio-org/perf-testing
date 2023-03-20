### Pre-requisite:
#### Generate data:
- Approach 1:
1. Go to database mod_inventory_storage.holdings_record, mod_inventory_storage.item, mod_users.users
2. Select jsonb->>'hrid' or jsonb->>'barcode' from table
3. Create .csv file with parameters from database.
4. Rename it properly according to the filenaming in .csv files from JMetr script.
#### Cleare the database:
  Examples
    For Items Bulk Edits
      TRUNCATE TABLE [tenant]_mod_patron_blocks.user_summary;
      TRUNCATE TABLE [tenant]_mod_circulation_storage.loan;
      TRUNCATE TABLE [tenant]_mod_circulation_storage.audit_loan;
      TRUNCATE TABLE [tenant]_mod_circulation_storage.request;
      TRUNCATE TABLE [tenant]_mod_circulation_storage.patron_action_session;
      TRUNCATE TABLE [tenant]_mod_circulation_storage.scheduled_notice;
      TRUNCATE TABLE [tenant]_mod_notify.notify_data;
      UPDATE [tenant]_mod_inventory_storage.item SET jsonb = jsonb_set(jsonb, '{status, name}', '"Available"') WHERE jsonb->'status'->>'name' != 'Available';
      UPDATE [tenant]_mod_inventory_storage.item SET jsonb = jsonb_set(jsonb, '{permanentLocationId}', '"08863ef2-508d-491e-9603-b6e1272f6855"') where jsonb->'permanentLocationId' != '"08863ef2-508d-491e-9603-b6e1272f6855"' and jsonb->'barcode' is not null and jsonb->'barcode' >= '"000"' and jsonb->'barcode'<= '"090155243"';
      UPDATE [tenant]_mod_inventory_storage.item SET jsonb = jsonb_set(jsonb, '{temporaryLocationId}', '"6216269b-9c9e-4129-adc5-ca9397137edc"') where jsonb->'temporaryLocationId' is null and jsonb->'barcode' is not null and jsonb->'barcode' >= '"000"' and jsonb->'barcode'<= '"090155243"';
      UPDATE [tenant]_mod_inventory_storage.item SET jsonb = jsonb_set(jsonb, '{permanentLoanTypeId}', '"ac19815e-1d8e-473f-bd5a-3193cb301b8b"') where jsonb->'permanentLoanTypeId' != '"ac19815e-1d8e-473f-bd5a-3193cb301b8b"' and jsonb->'barcode' is not null and jsonb->'barcode' >= '"000"' and jsonb->'barcode'<= '"090155243"';
      UPDATE [tenant]_mod_inventory_storage.item SET jsonb = jsonb_set(jsonb, '{temporaryLoanTypeId}', '"23e4f1ec-cf31-4098-959e-de64ce4781ce"') where jsonb->'temporaryLoanTypeId' is null and jsonb->'barcode' is not null and jsonb->'barcode' >= '"000"' and jsonb->'barcode'<= '"090155243"';
    
    For Holdings Bulk Edits
      UPDATE [tenant]_mod_inventory_storage.holdings_record SET jsonb = jsonb_set(jsonb, '{permanentLocationId}', '"fac5de34-26ee-456d-86b1-f04fdf680d65"') WHERE jsonb->'hrid'>='"ho9825487"' and jsonb->'hrid'<='"ho9999999"' and jsonb->'permanentLocationId'!='"fac5de34-26ee-456d-86b1-f04fdf680d65"';
      UPDATE [tenant]_mod_inventory_storage.holdings_record SET jsonb = jsonb_set(jsonb, '{temporaryLocationId}', '"2b8f7d63-706a-4b56-8a5e-50ad24e33e4c"') WHERE jsonb->'hrid'>='"ho9825487"' and jsonb->'hrid'<='"ho9999999"' and jsonb->'temporaryLocationId' is null;
    
    For Users Bulk Edits
      UPDATE [tenant]_mod_users.users SET jsonb = jsonb_set(jsonb, '{personal,email}', '"[email]"') where jsonb->'barcode' is not null and jsonb->'personal'->>'email' = '[email]';
      UPDATE [tenant]_mod_users.users SET jsonb = jsonb - 'expirationDate' where jsonb->'barcode' is not null and jsonb->'expirationDate' is not null;
      UPDATE [tenant]_mod_users.users SET jsonb = jsonb_set(jsonb, '{patronGroup}', '"5fc96cbd-a860-42a7-8d2b-72af30206712"') where jsonb->'barcode' is not null and jsonb->'patronGroup' = '"294db32c-0675-4dd5-8c5f-e3974c4ab6f2"';

#### Workflow steps:
1. Open Bulk Edit App
2. Upload a .csv file with records
3. Download matched records file
4. Coose parameter to edit
5. Confirm editing
6. Download a preview of the changes
7. Commit changes

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-bulk-operations
- mod-inventory
- mod-inventory-storage
- mod-data-export worker
- mod-data-export-spring
- okapi

##### Frontend:
- ui-users
- ui-inventory
- ui-bulk-edit