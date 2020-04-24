## Workflow steps:

##### Workflow for requests_searchByOpenStatus.jmx

Search request by open status

1. Open Requests App
2. Select Request status drop down and select all open statuses:
- Open - Awaiting delivery
- Open - Awaiting pickup
- Open - In transit
- Open - Not yet filled

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-circulation-18.0.7
- mod-circulation-storage-11.0.0
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.35.2
##### Frontend:
- ui-circulation-2.0.0

- FOLIO release: FameFlower

## Steps to run JMeter script:
##### Using GUI:
1. Open .jmx file in JMeter IDE
2. Change credentials in jmeter-supported-data\credentials.csv 
_[folio username],[folio password],[tenantId]_
3. Change hostname in User Defined Variables
4. Click to the play button

##### NON GUI mode
run the command:

jmeter -n -t [path_to_project]/perf-testing/workflows-scripts/request-search/searchRequestByOpenStatus.jmx -l [path_to_project]/perf-testing/workflows-scripts/request-search/log.jtl

where [path_to_project] - a path to perf-testing project


