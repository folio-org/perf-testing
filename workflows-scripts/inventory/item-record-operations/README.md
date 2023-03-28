## Workflow steps:
##### Workflow for item_recordOperations.jmx

View Item:

1. In the Keyword field, search for the item by a unique name or by an item's identifier such as HRID or barcode
2. The found item's associated instance will be displayed in the third (right) pane. 
3. In the third pane (detailed instance's view), click on a holdings entry and click on the item's barcode to launch the item's detailed page

Edit Item:

1. In the Keyword field, search for the item by a unique name or by an item's identifier such as HRID or barcode
2. The found item's associated instance will be displayed in the third (right) pane. 
3. In the third pane (detailed instance's view), click on a holdings entry and click on the item's barcode to launch the item's detailed page
4. Click on the Action and select Edit to edit an item record
5. Update one or several fields
6. Hit Save and Close

Delete User:

1. In the Keyword field, search for the item by a unique name or by an item's identifier such as HRID or barcode
2. The found item's associated instance will be displayed in the third (right) pane. 
3. In the third pane (detailed instance's view), click on a holdings entry and click on the item's barcode to launch the item's detailed page
4. Click on the Action and select Delete to delete an item record
5. In the pop up window that confirms deletion, click on Delete

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users-19.0.0
- mod-users-bl-7.4.0
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- mod-gobi-2.5.0
- mod-ebsconet-1.4.0
- mod-inventory-19.0.1
- okapi-4.14.7
##### Frontend:
- folio_users-8.2.0
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- search_items.csv: a list of instance hrid for Search field that will be used to execute the script.
- credentials.csv: a file to specify credentials for the tenant being tested.
### Non-runtime Data
- item-data-load.sh : the file is used to recreate the DB data with affected instances 2K-items.tsv
- files should be in the same directory to run the bash script with command: item-data-load.sh [instance_configs].conf [tenant]

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			by default -1 means run forever and it should be carefully used by running DELETE scenario. 
#### Probabilities of scenarios
- Prob_ViewUserLoans	View
- Prob_EditUser			Edit
- Prob_DeleteUser		Delete

## Setup data before running JMeter script:
- Restore DB from previously prepared backup with items.tsv file using item-data-load.sh file

## Run JMeter script
Example of command:
```shell
jmeter -n -t users_patronRecordOperations.jmx -JVUSERS=2 -l report.csv -e -o HTML
```

## Setup data after running JMeter script:
- Restore DB from items.tsv file using item-data-load.sh file