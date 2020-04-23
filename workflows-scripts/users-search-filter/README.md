## Workflow steps:
##### Workflow for users_search.jmx
1. Open Users App
2. Select Status dropdown
3. Check "active" status
4. Keep scrolling until you see Load More button (behind the scene, a query will be made to backend module by increasing offset)
5. Do point 4 couple of times (page renders very slow)

## Modules required to be enabled as a pre-requisite to run JMeter script:
- mod-inventory-storage-19.1.2
- mod-inventory-14.1.2
- FOLIO release: FameFlower

## Steps to run JMeter script:
##### Using GUI:
1. Open .jmx file in JMeter IDE
2. Change credentials in jmeter-supported-data\credentials.csv 
3. Change hostname in User Defined Variables
4. Click to the play button

##### Using non-GUI:
Navigate to Apache bin folder and run script.
For example:
Workspace/apache-jmeter-5.2.1/bin                          
▶ sudo ./jmeter.sh -n -t [path_to_project]/perf-testing/workflows-scripts/item-search-filter/users_search.jmx -l [path_to_project]/perf-testing/workflows-scripts/item-search-filter/result.jtl
