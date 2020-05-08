TRUNCATE TABLE fs09000000_mod_circulation_storage.loan;
TRUNCATE TABLE fs09000000_mod_circulation_storage.audit_loan;
TRUNCATE TABLE fs09000000_mod_circulation_storage.request;
TRUNCATE TABLE fs09000000_mod_circulation_storage.patron_action_session;
TRUNCATE TABLE fs09000000_mod_feesfines.feefines;
TRUNCATE TABLE fs09000000_mod_circulation_storage.scheduled_notice;
TRUNCATE TABLE fs09000000_mod_notify.notify_data;

UPDATE fs09000000_mod_inventory_storage.item 
	SET jsonb = jsonb_set(jsonb, '{status, name}', '"Available"') 
	WHERE jsonb->'status'->>'name' != 'Available';