## Modules required to be enabled as a pre-requisite to run JMeter script:
-mod-inventory-storage
-mod-authtoken
-mod-permissions
-okapi

## Usage
- This inventoryStorage_db_pool_utilization.jmx script that invokes the GET /instance-storage/instances/${instanceId} API. It uses a list of instances from instances.csv 
- Modify credentials.csv to have the correct values before running the script.

## Workflow steps:

##### Workflow for inventoryStorage_db_pool_utilization.jmx
1. Open script and edit the quantity of thread groups in accordance with amount of tenants and hosts (servers).
2. Open credentials.csv and edit login, password, tenant, server against which load should be performed.
3. Add data into instances.csv or create new files with appropriate names and data inside (depends on tenants). 
   If multi files are used then in every thread group CSV Data Set Config should contain link to it and should be sharable with current thread group.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users for each thread group.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script.
- LOOPS			by default -1 means run forever and it should be carefully used by running the script. 

## Run JMeter script
Example of command:
```shell
jmeter -n -t inventoryStorage_db_pool_utilization.jmx -JVUSERS=2 -l report.csv -e -o HTML
```