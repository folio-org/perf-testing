/*
To clear all generated data in request table, enter the commands:

*/


TRUNCATE TABLE ${TENANT}_mod_circulation_storage.request;

TRUNCATE TABLE ${TENANT}_mod_patron_blocks.user_summary;

TRUNCATE TABLE ${TENANT}_mod_circulation_storage.loan;

TRUNCATE TABLE ${TENANT}_mod_circulation_storage.audit_loan;

TRUNCATE TABLE ${TENANT}_mod_circulation_storage.request;

TRUNCATE TABLE ${TENANT}_mod_circulation_storage.patron_action_session;

TRUNCATE TABLE ${TENANT}_mod_feesfines.feefines;

TRUNCATE TABLE ${TENANT}_mod_circulation_storage.scheduled_notice;

TRUNCATE TABLE ${TENANT}_mod_notify.notify_data;