## Workflow steps:
##### Workflow for users_loan-renewal-by-barcode.jmx
1. Get all User's userBarcode
2. For each user, get all open loans
3. Iterate over all open loans
4. Renew all loans by barcode

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users-17.1.0
- mod-users-bl-6.0.0
- mod-authtoken-2.5.1
- mod-permissions-5.11.2
- mod-circulation-19.0.9
- mod-circulation-storage-12.0.1
- okapi-3.1.1

##### Frontend:
- folio_users-4.0.6

- FOLIO release: Goldenrod

As per requirements in JIRA, script will run against 
- 10 loans (1, 5, 10 users)
- 50 loans (1, 5, 10 users)
- 100 loans (1, 5, 10 users)
- 200 loans (1, 5, 10 users)

## Setup data before running JMeter script:
- checkin-checkout-db-restore.sql:
This is the same script from check-in-check-out. It restores the DB to its original state. This script should be run after each test run to ensure that subsequent test runs have the same starting point. This script truncates all loans and requests and their associated tables, and also restores all the inventory items' status to "Available".

`psql -h gcp1-db-01.c5cqgppfbl8c.us-east-1.rds.amazonaws.com -d folio -U folio -f checkin-checkout-db-restore.sql -a --echo-all`

- Create open loans for user:
`psql -h gcp1-db-01.c5cqgppfbl8c.us-east-1.rds.amazonaws.com -d folio -U folio -a -c "\copy fs09000000_mod_circulation_storage.loan(id, jsonb) FROM loans_5.tsv DELIMITER E'\t'"`