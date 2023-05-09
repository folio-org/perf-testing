## Workflow steps:
##### Workflow for patron_recordView.jmx

View patron record:

Simulate Blacklight calling FOLIO APIs to view a patron record in a JMeter script:

- POST /authn/login
- GET /users/{uuid}
- GET /users 
- GET circulation/requests with 50% probability

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users-19.0.0
- mod-users-bl-7.4.0
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- okapi-4.14.7
##### Frontend:
- folio_users-8.2.4
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- user_ids.csv: a list of uuids and names of actual users that will be used to execute the script.
- credentials.csv: a file to specify credentials for the tenant being tested. Username, password and tenant should be replaced by valid data.

### Parameters
#### Environment and Configuration
- HOSTNAME
- PRV_vusers		count of concurrent users.
- PRV_rampup		the amount of time it will take the script to add all test users (threads) to a test execution.
- PRV_duration		timespan between start and end of the script
- PRV_loop			by default -1 means run forever and it should be carefully used by running DELETE scenario.

## Run JMeter script
Example of command:
```shell
jmeter -n -t users_patronRecordOperations.jmx -JVUSERS=2 -l report.csv -e -o HTML
```