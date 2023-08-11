## Workflow steps:

##### Workflow for List_app.jmx
Refresh list:

1. Go to list in List App
2. Simulate refresh
   Wait untill refresh finished.
3. "LA_TC: Refresh List" is a transaction controller which shows total refresh time.

## Modules required(minimum required version) to be enabled as a pre-requisite to run JMeter script:

Attached in the file: list-app-modules.rtf

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- LA_list_id.csv: a list of listIDs for refreshing.

### Parameters
#### Environment and Configuration
- HOSTNAME
- LA_vusers		count of concurrent users.
- LA_rampup		the amount of time it will take the script to add all test users (threads) to a test execution.
- Global_duration		timespan between start and end of the script

## Setup data before running JMeter script:
- On the carrier go to cd /home/ec2-user/circ-data-load/ListApp
- run the command export PGPASSWORD='[DB password]';psql -f checkin-checkout-db-restore.sql -a --echo-all -h [DB host] -U [DB name]
- after previous command finished: ./circ-data-load.sh psql_[environment name].conf [tenant]

## Setup data after running JMeter script:
- Restore a DB: On the carrier go to cd /home/ec2-user/circ-data-load/ListApp
- run the command export PGPASSWORD='[DB password]';psql -f checkin-checkout-db-restore.sql -a --echo-all -h [DB host] -U [DB name]