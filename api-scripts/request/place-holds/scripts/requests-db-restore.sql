/*
To use this script, enter the command:
$ psql -f requests-db-restore.sql -a --echo-all
Also supply the values for -h, -d, -U if applicable

This script will remove all the requests. It is expected that these requests will be repopulated by another script.
Lastly the script update inventory Items' status to Available (because their status got changed to Paged or other statuses during the test run.)
*/


TRUNCATE TABLE fs09000000_mod_circulation_storage.request;

UPDATE fs09000000_mod_inventory_storage.item 
	SET jsonb = jsonb_set(jsonb, '{status, name}', '"Available"') 
	WHERE jsonb->'status'->>'name' != 'Available';