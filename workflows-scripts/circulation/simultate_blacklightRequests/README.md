## Workflow steps:

##### view_inventoryRecord.jmx The script was created to monitor inventory records
Simulate Blacklight's calling FOLIO to view a record by issuing the following API calls:

- GET item-storage/items 												
- GET item-storage/items/{uuid}											
- PUT /item-storage/item/{uuid} (setting a value in the piecesOfDescription field)	
- POST /item-storage/item  (for serial requests - creates a dummy item when the requested record is a serial)
- GET /users/{uuid}
- GET patron/account/{uuid}
- POST circulation/request (filling out the minimum required fields in the POST body).

## Modules required(minimum required versions) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-25.0.4
- mod-inventory-19.0.2
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- mod-source-record-storage-5.5.2
- okapi-4.14.7
##### Frontend:
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- BLS_instance_user_ids.csv: a list of instance and item ids to run the script.
- credentials.csv: a file to specify credentials for the tenant being tested (contains username,password,tenant, they are needed for login).

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			by default -1 means run forever and it should be carefully used by running EDIT & DELETE scenario.

#### NOTES for the flow
All API calls are being made once

## Setup data before running JMeter script:
- Extract the data from DB with intance ids from FROM [tenant]_mod_inventory.records_instances with 200 lines; 
- Extract the data from DB with user ids from FROM [tenant]_mod_inventory.records_users with 200 lines; 
- Put extracted data into the VIR_instance_item.csv file in format: instance_id,item_id

## Run JMeter script
Example of command:
```shell
jmeter -n -t organization_crudOperations.jmx -JVUSERS=2 -l report.csv -e -o HTML
