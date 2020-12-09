## Workflow steps:

##### api for GET_loan-storage_loans.jmx
1. GET /loan-storage/loans?query=(userId==${user_id} and status.name<>Closed)



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