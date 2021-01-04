In this workflow, we are checking the performance of POST /loan-storage/loans API for creating loans in bulk. IC's normally create loans in bulk using mod-circulation business logic which is slow. This script will investigate if the same can be done using the mod-circulation-storage module bypassing business logic.

### Pre-requisite:
#### Generate data:
1. Log into database
2. Run Postgresql query to generate item ids 
For example ```SELECT distinct id FROM fs09000000_mod_inventory_storage.item where jsonb->'status'->>'name'='Available' LIMIT 90000;```
3. Save all ids in itemsId.csv file and use it in JMeter for creating loan
4. Run the script to restore the DB after running JMX script: https://github.com/folio-org/perf-testing/blob/master/workflows-scripts/circulation/check-in-check-out/scripts/checkin-checkout-db-restore.sql

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-circulation-storage
- okapi
- mod-authtoken

Check report for more details:
https://wiki.folio.org/pages/viewpage.action?pageId=52135330