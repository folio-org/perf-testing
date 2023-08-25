## Workflow steps:
##### Workflow for users_loanRenewals.jmx
1. Get all User's userBarcode
2. For each user, get all open loans
3. Iterate over all open loans
4. Renew all loans by barcode

##### FOLIO releases:
- Goldenrod
- Orchid

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users
- mod-users-bl
- mod-authtoken
- mod-permissions
- mod-circulation
- mod-circulation-storage
- okapi

##### Frontend:
- folio_users

The script will run against 
- 10 loans (1, 2 users)
- 50 loans (1, 2 users)
- 100 loans (1, 2 users)
- 200 loans (1, 2 users)
- Depending on the slowness of workflow, decision will be made if the test will run for more than 2 concurrent users.

## Setup data before running JMeter script:
- checkin-checkout-db-restore.sql:
This is the same script from check-in-check-out. It restores the DB to its original state. This script should be run after each test run to ensure that subsequent test runs have the same starting point. This script truncates all loans and requests and their associated tables, and also restores all the inventory items' status to "Available".
`psql -f checkin-checkout-db-restore.sql -a --echo-all`

- Create open loans for user:
`"\copy fs09000000_mod_circulation_storage.loan(id, jsonb) FROM loans_5.tsv DELIMITER E'\t'"`
