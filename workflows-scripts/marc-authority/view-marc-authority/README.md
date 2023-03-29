## Workflow steps:
##### Workflow for marc_viewAuthorityRecord.jmx

View MARC Authority Record:

1. Go to MARC Authority app 
2. In the Search & filter left pane, do a Keyword search (Using the Search option)
3. Results will appear in the middle pane.
4. Click on any result in the result list to view the detail authority record
Repeat step 4 by clicking on other results in the result list to bring up other MARC authority records to view.

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users-19.0.0
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- mod-inventory-19.0.1
##### Frontend:
- folio_users-8.2.0
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- search_marc_keyword.csv: a list of search keywords for marc authority records.
- credentials.csv: a file to specify credentials for the tenant being tested.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			by default -1 means run forever and it should be carefully used by running DELETE scenario. 
#### Probabilities of scenarios
- prob_viewAuthority	View

## Setup data before running JMeter script:
- Restore DB not needed

## Run JMeter script
Example of command:
```shell
jmeter -n -t users_patronRecordOperations.jmx -JVUSERS=2 -l report.csv -e -o HTML
```