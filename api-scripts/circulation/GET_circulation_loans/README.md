## Workflow steps:

##### api for GET_circulation_loans.jmx
1. GET /circulation/loans?query=(userId==${user_id} and status.name<>Closed)



## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-circulation-18.0.9
- mod-circulation-storage-11.0.0
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.38.0
##### Frontend:
- folio_circulation-2.0.0

- FOLIO release: HONEYSOUCKLE

To run test properly:
- Restore DB using checkin-checkout-db-restore.sql script;
- Seed database with data using circ-data-load.sh script;
- To find proper itemUUIDs the best way is to run  /loan-storage/loans&limit=2147483647 and select needed amount of user_id needed;
- Populate userIDs.csv with user_id from previous step;
- Test is ready for execution.