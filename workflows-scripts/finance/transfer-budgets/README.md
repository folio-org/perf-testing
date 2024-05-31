## Workflow steps:

##### Workflow for finance_fund_transfer_budgets.jmx
Finance Fond Budget Allocation:
1. Go to finance app
2. Create Funds
3. Create Current Budgets
4. Click on created fund
5. Click on a current budget
6. Click Transfer
7. Fill in amount and select from and to budgets
8. click Confirm


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
- mod-di-converter-storage:2.2.2
##### Frontend:
- folio_finance-3.3.2
- FOLIO release: Quesnelia

### Parameters
#### Environment and Configuration
- HOSTNAME
- TB_VUSERS		count of concurrent users.
- TB_RAMP_UP	the amount of time it will take the script to add all test users (threads) to a test execution.
- TB_TRANSFER_COUNT   count of transfer between budgets
- DURATION		timespan between start and end of the script
- DISTRIBUTION  Distribution of flows. By default, 0-100-0-0 probabilities for create-view-update-delete operations
## Setup data before running JMeter script:
- Edit credentials, username, password and central and member tenants if consortia like environment.
- Point tenant with sourceTenantId variable. The central tenant with targetTenantId variable.

## Setup data after running JMeter script:
- Script creates funds and budgets, perform transfer between budgets.