## Workflow steps:

##### api for GET_circulation_loans.jmx
1. GET /circulation/loans?query=(userId==${user_id} and status.name<>Closed)



## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-circulation
- mod-circulation-storage
- mod-authtoken
- mod-permissions
- okapi
##### Frontend:
- folio_circulation

- FOLIO release: Honeysuckle/Goldenrod

To run test properly:
- Restore DB using checkin-checkout-db-restore.sql script;
- Seed database with data using circ-data-load.sh script;
- To find proper itemUUIDs the best way is to run  /loan-storage/loans&limit=2147483647 and select needed amount of user_id needed;
- Populate userIDs.csv with user_id from previous step;
- Test is ready for execution.