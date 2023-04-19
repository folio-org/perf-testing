## Workflow steps:

##### Workflow for invoices_approveInvoices.jmx
Approve Invoices:

1. Go to Invoices App
2. Simulate two possibilities if doable (50/50 chance)
   1. In the Search & Filter pane, Select "Open" status
   2. Enter a Vendor Invoice Number, hit Search
3. Click on a Vendor Invoice Number in the result list
4. View the invoice details on the third pane
5. Click on Actions -> Approve Invoice (Please see video instructions)

## Modules required(minimum required version) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-authtoken-2.14.0
- mod-permissions-6.3.1
- okapi-4.14.7
- mod-users-19.1.0
- mod-orders-12.6.4
- mod-invoice-5.7.0
- mod-organizations-storage-4.6.0
- mod-invoice-storage-5.6.0
##### Frontend:
- folio_invoice-4.0.100000219

- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- invoice_codes.csv: a list of keywords for searching invoices
- credentials.csv: a file to specify credentials for the tenant being tested.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- VIEW_DISTRIBUTION  Distribution of flows. By default, 50-50 probabilities for search open and by name
## Setup data before running JMeter script:
- Take a DB Dump({tenant}_mod_finance_storage.invoice table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764
- Select data from database using script 
```SQL
  SELECT {tenant}_mod_invoice_storage.invoices.jsonb->'vendorInvoiceNo'
	FROM {tenant}_mod_invoice_storage.invoices limit 2000;
```
- Put selected data into invoice_codes.csv
## Setup data after running JMeter script:
- Restore a DB Dump({tenant}_mod_finance_storage.invoice table) as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764