## Workflow steps:

##### Workflow for finance_managingLedgers.jmx
View Ledger:

1. Go to the Finance app, search for a ledger by name
2. Click on the ledger in the result list to view it

Create Ledger: 

1. Go to the Finance app
2. Click on the "actions"->"new" button
3. Enter valid data
4. Click on the "Save & Close" button

Edit Ledger:

1. Go to the Finance app, search for a ledger by name
2. Click on the ledger in the result list to view it
3. Click on the ledger's Actions menu then Edit
4. Modify a ledger's description
5. Hit Save and Close button.

Delete Ledger:

1. Go to the Finance app, search for a ledger by name
2. Click on the ledger in the result list to view it
3. Click on the ledger's Actions menu then Delete
4. Confirm Delete on the pop-up menu

## Modules required(minimum required version) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-25.0.4
- mod-inventory-19.0.2
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- okapi-4.14.7
- mod-finance-4.6.2
- mod-users-19.0.0
- mod-orders-12.5.4
- mod-finance-storage-8.3.1
##### Frontend:
- folio_finance-3.3.2

- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- keywords.scv: a list of keywords for searching ledger and id
- credentials.csv: a file to specify credentials for the tenant being tested.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- DISTRIBUTION  Distribution of flows. By default, 0-100-0-0 probabilities for create-view-update-delete operations
## Setup data before running JMeter script:
- Take a DB Dump({tenant}_mod_finance_storage.ledger table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764
- Select data from database using script 
```SQL
  SELECT {tenant}_mod_finance_storage.ledger.jsonb->'name', id
  FROM {tenant}_mod_finance_storage.ledger;
```
- If not enough records you can run this JMeter script with DISTRIBUTION = 100-0-0-0 and goto previous step.
- Put selected data into keywords.csv

## Setup data after running JMeter script:
- Restore a DB Dump({tenant}_mod_finance_storage.ledger table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764