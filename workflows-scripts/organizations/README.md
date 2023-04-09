## Workflow steps:

##### organization_crudOperations.jmx The script was created to Create, View, Update and Delete organization (vendor)
Create a vendor:

1. Go to organizations App, press New, fill in obligatory fields, organization status should be active
2. Press Save and Close

View a vendor:

1. Go to Organizations App
2. Simulate two possibilities if doable (50/50 chance) 
	2.1 Searching by a Vendor name (Select "Name" from drop down list in the left panel) and enter a vendor name and hit Search
	2.2 On the Search & Filter panel, under the section "Organization Status", check the box "Active"	
3. When the result(s) come back, select a/the vendor name
4. View the vendor record on the third pane.

Update a vendor:

1. Go to Organizations App
2. Searching by a Vendor name (Select "Name" from drop down list in the left panel) and enter a vendor name and hit Search
3. When the result(s) come back, select the vendor name
4. View the vendor record on the third pane, select Action -> Edit
5. Make some trivial changes to the vendor like the Description, hit Save and Close

Delete a vendor:

1. Go to Organizations App
2. Searching by a Vendor name (Select "Name" from drop down list in the left panel) and enter a vendor name and hit Search
3. When the result(s) come back, select the vendor name
4. View the vendor record on the third pane. Click on Actions -> Delete
5. Confirm deletion in the pop-up message.

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
- folio_organizations-4.0.100000218
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- organizationNames.scv: a list of organization names that will be used to execute view, edit, delete operations in the script.
- credentials.csv: a file to specify credentials for the tenant being tested (contains username,password,tenant, they are needed for login).

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			by default -1 means run forever and it should be carefully used by running EDIT & DELETE scenario. 

#### Probabilities of scenarios
- prob_createVendor		Create
- prob_viewVendor		View
- prob_editVendor		Edit
- prob_deleteVendor		Delete

## Setup data before running JMeter script:
- Populate DB with vendors for edit and delete scenario and use these vendor names to edit & delete vendors
- Run Create scenario for 30 minutes to generate 500 vendors
- Extract new created vendors names from DB to organizationNames.csv file

## Run JMeter script
Example of command:
```shell
jmeter -n -t users_patronRecordOperations.jmx -JVUSERS=2 -l report.csv -e -o HTML
```
## Setup data after running JMeter script:
- Restore a DB by running Delete scenario