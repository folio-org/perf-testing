Orders_for_EDIFACT.jmx
This test script was created to generate orders for 10 organizations and enable mod-data-export-spring. Before enabling mod-data-export-spring check if the script has a proper mod version. 

To delete orders from the database using the query "TRUNCATE TABLE fs09000000_mod_orders_storage.purchase_order CASCADE"

To delete all jobs data from the database - "TRUNCATE TABLE fs09000000_mod_data_export_spring.job CASCADE"

EDI_test_organizations.txt - file with 10 organizations' details for EDI testing