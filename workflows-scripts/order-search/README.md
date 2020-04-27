## Workflow steps:

##### Workflow for requests_searchByOpenStatus.jmx

Search order lines by open status

1. Open Orders App
2. Select Order lines tab in top left
3. Select one of statuses in Receipt status

##### Workflow for orders_searchById.jmx

Search order by id

1. Open Orders App
2. Select Order tab in top left
3. Select Po Number in search listbox
4. Put "msl1AAH" in search field
5. Choose one of orders which has vendor code (e.x. the order with poNumber: "msl1AAH7759")

##### Workflow for orders_searchByKeyword.jmx

Search order by keyword

1. Open Orders App
2. Select Order tab in top left
3. Select Keyword in the search dropdown
3. Write "test" in the search field

##### Workflow for orders_searchByStatus.jmx

Search order by status

1. Open Orders App
2. Select Order tab in top left
3. Select one of statuses (Open, Closed, Pending)

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-orders-10.0.3
- mod-orders-storage-10.0.1
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.35.2
##### Frontend:
- folio-orders-2.0.3

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

jmeter -n -t [path_to_project]/perf-testing/workflows-scripts/request-search/[file_name].jmx -l [path_to_project]/perf-testing/workflows-scripts/request-search/log.jtl

where [path_to_project] - a path to perf-testing project
	  [file_name] - a jmx file name 



