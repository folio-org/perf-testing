## Modules required to be enabled as a pre-requisite to run JMeter script:
-mod-inventory-storage
-mod-authtoken
-mod-permissions
-okapi

## Usage
- This inventoryStorage_db_pool_utilization.jmx script that invokes the GET /instance-storage/instances/${instanceId} API. It uses a list of instances from instances.csv 
- Modify credentials.csv to have the correct values before running the script.

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script.
- LOOPS			by default -1 means run forever and it should be carefully used by running the script. 

## Run JMeter script
Example of command:
```shell
jmeter -n -t inventoryStorage_db_pool_utilization.jmx -JVUSERS=10 -l report.csv -e -o HTML
```