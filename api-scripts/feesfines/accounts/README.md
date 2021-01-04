## Workflow steps:

##### api for GET_accounts.jmx
1. GET /accounts?query=loanId==(<loanUUID> or <loanUUID>)&limit=2147483647



## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-authtoken-2.4.0
- mod-inventory-storage:19.4.4
- okapi:4.3.3
##### Frontend:
- folio_circulation-2.0.0

- FOLIO release: Honeysuckle

#####
To run this test properly:
1) Run /workflows-scripts/circulation/check-in-check-out/scripts/  scripts to restore/seed database;
2) Run /DataPreparation/AccountCreation AccountCreation.jmx
3) Run Test.