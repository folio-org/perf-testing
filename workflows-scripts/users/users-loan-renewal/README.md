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