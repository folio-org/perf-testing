## Workflow steps:

##### Workflow for invoices_manageInvoices.jmx
View Invoice:

1. Go to the Invoices app, search for an invoice by name
2. Click on the invoice in the result list to view it

Create Invoice: 

1. Go to the Invoices app,
2. Click on the "actions"->"new" button
3. Enter valid data
4. Choose vendor
5. Click on the "Save & Close" button

View Invoices

1. Go to Invoices App
2. Simulate two possibilities if doable (50/50 chance)  
   1. In the Search & Filter pane, Select "Open" status 
   2. Enter a Vendor Invoice Number, hit Search
3. Click on a Vendor Invoice Number in the result list
4. View the invoice details on the third pane

Update Invoices

1. Go to Invoices App
2. Enter a Vendor Invoice Number, hit Search
3. Click on a Vendor Invoice Number in the result list
4. View the invoice details on the third pane. Click on Actions -> Edit
5. Modify some trivial fields, such as Note
6. Click on Save & Close

Delete Invoices:

1. Go to Invoices App
2. Enter a Vendor Invoice Number, hit Search
3. Click on a Vendor Invoice Number in the result list
4. View the invoice details on the third pane. Click on Actions -> Delete
5. Confirm deletion in the popup window

## Modules required(minimum required version) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- okapi-4.14.7
- mod-users-19.0.0
- mod-orders-12.5.4
- mod-invoice-5.5.0
- mod-organizations-storage-4.4.0
- mod-invoice-storage-5.5.0
##### Frontend:
- folio_invoice-3.3.1

- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- invoice_codes.csv: a list of keywords for searching invoices
- organization_names.csv: a list of keywords for searching organization(only for create workflow)
- credentials.csv: a file to specify credentials for the tenant being tested.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- DISTRIBUTION  Distribution of flows. By default, 0-100-0-0 probabilities for create-view-update-delete operations
- VIEW_DISTRIBUTION  Distribution of flows. By default, 50-50 probabilities for search open and by name
## Setup data before running JMeter script:
- Take a DB Dump({tenant}_mod_finance_storage.invoice table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764
- Select data from database using script 
```SQL
  SELECT {tenant}_mod_invoice_storage.invoices.jsonb->'vendorInvoiceNo'
	FROM {tenant}_mod_invoice_storage.invoices limit 2000;
```
- If not enough records you can run this JMeter script with DISTRIBUTION = 100-0-0-0 and goto previous step.
- Put selected data into invoice_codes.csv
- Select data from database using script
```SQL
  SELECT DISTINCT({tenant}_mod_organizations_storage.organizations.jsonb->'code')
	FROM {tenant}_mod_organizations_storage.organizations limit 2000;
```
- Put selected data into organization_names.csv and remove all symbols #,$,*,@ ...
## Setup data after running JMeter script:
- Restore a DB Dump({tenant}_mod_finance_storage.invoice table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764