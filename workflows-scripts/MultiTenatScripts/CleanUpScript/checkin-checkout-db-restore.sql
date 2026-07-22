/* To use this script, enter the command:
$ psql -f checkin-checkout-db-restore.sql -a --echo-all
Also supply the values for -h, -d, -U if applicable

This script will remove all the loans and requests, and their related data from the tables. It is expected that these loans and requests will be repopulated by another script.
Lastly the script update inventory Items' status to Available (because their status got changed to Checked out or In transit during the test run.)
*/

TRUNCATE TABLE tenant_mod_patron_blocks.user_summary;
TRUNCATE TABLE tenant_mod_circulation_storage.loan;
TRUNCATE TABLE tenant_mod_circulation_storage.audit_loan;
TRUNCATE TABLE tenant_mod_circulation_storage.request;
TRUNCATE TABLE tenant_mod_circulation_storage.patron_action_session;
TRUNCATE TABLE tenant_mod_feesfines.feefines;
TRUNCATE TABLE tenant_mod_circulation_storage.scheduled_notice;
TRUNCATE TABLE tenant_mod_notify.notify_data;

UPDATE tenant_mod_inventory_storage.item 
	SET jsonb = jsonb_set(jsonb, '{status, name}', '"Available"')
	WHERE jsonb->'status'->>'name' != 'Available';

