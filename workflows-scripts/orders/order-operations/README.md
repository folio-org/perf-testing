## Workflow steps:

##### purchase_orderOperations.jmx The script was created to Create, View, Update and Delete Orders
Create Order:

1. Go to Orders App
2. Choose Orders on Search and Filter pane, click Actions New.
3. To fill in all obligatory fields choose Perf_template from the dropdown menu.
4. Press Save and Close

View Order:

1. Go to Orders App
2. Choose Orders on Search and Filter pane
3. Click Vendor, then Organization look-up
4. Find Vendor_perf in Organization app (here we use Organizations app search)
5. When the result(s) come back, select a/the PO number
6. View the PO record on the third pane.

Update Order:

1. Go to Orders App
2. Choose Orders on Search and Filter pane
3. Click Vendor, then Organization look-up
4. Find Vendor_perf in Organization app (here we use Organizations app search)
5. When the result(s) come back, select a/the PO number
6. View the PO record on the third pane
7. Click Actions -> Edit
8. Make some changes to the Order like the Note, hit Save and Close

Delete Order:

1. Go to Orders App
2. Choose Orders on Search and Filter pane
3. Click Vendor, then Organization look-up
4. Find Vendor_perf in Organization app (here we use Organizations app search)
5. When the result(s) come back, select a/the PO number
6. View the PO record on the third pane
7. Click Actions -> Delete
8. Confirm deletion in the pop-up message.

## Modules required(minimum required versions) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-authtoken-2.14.0
- mod-permissions-6.3.1
- mod-organizations-1.8.0
- mod-organizations-storage-4.6.0
- mod-orders-12.6.4
- mod-calendar-2.4.2
- okapi-5.0.1
##### Frontend:
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- vendors.csv: a list of vendors ids that have all needed checkers to create order. It will be used to execute create, view, edit, delete orders in the script.
- credentials.csv: a file to specify credentials for the tenant being tested (contains username,password,tenant, they are needed for login).
- vendors and credentials are mandatory and should be modified before script start
- by default vendor_id predefined for single environment usage in configuration viriables

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			by default -1 means run forever and it should be carefully used by running EDIT & DELETE scenario. 

#### Distribution variables
- order_create		Create
- order_view		View
- order_edit		Edit
- order_delete		Delete

## Setup data before running JMeter script:
- Populate DB with orders for view, edit and delete scenarios

## Run JMeter script
Example of command:
```shell
jmeter -n -t organization_crudOperations.jmx -JVUSERS=2 -l report.csv -e -o HTML
```
## Setup data after running JMeter script:
- Restore a DB by running Delete scenario