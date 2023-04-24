## Workflow steps:

##### Workflow for finance_rolloverLedgers.jmx
Rollover Ledger:
1. Goto rollover
2. Enter valid data
3. Click TEST ROLLOVER button
4. In pop-up window click CONTINUE
5. In pop-up window click CONFIRM
6. Click ROLLOVER button
7. In pop-up window click CONTINUE
8. In pop-up window click CONFIRM

## Modules required(minimum required version) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-25.0.4
- mod-inventory-19.0.2
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- okapi-4.14.7
- mod-finance-4.6.2
- mod-orders-12.5.4
- mod-finance-storage-8.4.1
##### Frontend:
- folio_finance-3.3.2

- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- ledgers_ids.scv: a list of keywords for searching ledger and id
- credentials.csv: a file to specify credentials for the tenant being tested.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- DISTRIBUTION  Distribution of flows. By default, 0-100-0-0 probabilities for create-view-update-delete operations
## Setup data before running JMeter script:
- Take a DB Dump({tenant}_mod_finance_storage.ledger_fiscal_year_rollover, {tenant}_mod_finance_storage.ledger_fiscal_year_budget, {tenant}_mod_finance_storage.ledger_fiscal_year_error, {tenant}_mod_finance_storage.ledger_fiscal_year_process table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764
- Select data from database using script 
```SQL
  SELECT DISTINCT({tenant}_mod_finance_storage.ledger.id)
	FROM {tenant}_mod_finance_storage.ledger
	LEFT OUTER JOIN {tenant}_mod_finance_storage.ledger_fiscal_year_rollover
	ON {tenant}_mod_finance_storage.ledger_fiscal_year_rollover.ledgerid = {tenant}_mod_finance_storage.ledger.id;
```
- Put selected data into ledger_ids.csv

## Setup data after running JMeter script:
- Restore a DB Dump({tenant}_mod_finance_storage.ledger table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764