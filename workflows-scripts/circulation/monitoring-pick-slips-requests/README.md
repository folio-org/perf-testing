## Workflow steps:

##### monitoring_pickSlipsRequests.jmx The script which monitore Pick Slips and Requests
Create a JMeter script that contains the following API calls at the rate indicated. 

1. /circulation/pick-slips/<servicepointId> : 20 per minute (sequentially called)
2. /circulation/requests : 1 per minute
3. /service-points : 1 per hour
4. /locations : 1 per hour

The JMeter script needs to have a CSV file that contains at least 20 service point IDs to be called over and over again. 

## Modules required(minimum required versions) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-authtoken-2.14.0
- mod-permissions-6.3.1
- mod-organizations-1.8.0
- mod-organizations-storage-4.6.0
- okapi-5.0.1
##### Frontend:
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- servicepoints.csv: a list of service point ids. It will be used to execute /circulation/pick-slips/<servicepointId> request.
- credentials.csv: a file to specify credentials for the tenant being tested (contains username,password,tenant, they are needed for login).
- servicepointId and credentials are mandatory and should be modified before script start

### Parameters
#### Environment and Configuration
- HOSTNAME
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			by default -1 means run forever and it should be carefully used by running EDIT & DELETE scenario. 