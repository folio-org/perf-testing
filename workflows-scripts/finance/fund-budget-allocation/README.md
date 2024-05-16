## Workflow steps:

##### Workflow for finance_fund_budget_increase_decrease.jmx
Finance Fond Budget Allocation:
1. Go to finance app
2. Create Fund
3. Create Current Budget
4. Click on created fund
5. Click on a current budget
6. In action section choose Increase allocation
7. Fill in sum and click Save
8. Wait 10 seconds
9. Click on created fund
10. Click on a current budget
11. In action section choose Decrease allocation
12. Fill in sum and click Save
13. Delete Budget
14. Delete Fund

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
- FFBA_VUSERS		count of concurrent users.
- FFBA_RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- DISTRIBUTION  Distribution of flows. By default, 0-100-0-0 probabilities for create-view-update-delete operations
## Setup data before running JMeter script:
- Edit credentials, username, password and central and member tenants if consortia like environment.
- Point tenant with sourceTenantId variable. The central tenant with targetTenantId variable.

## Setup data after running JMeter script:
- Script creates fund and budget, perform increasing and decreasing allocation actions and delete budget and fund after.