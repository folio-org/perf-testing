## Workflow steps:
##### Workflow for inventory_instanceSearch.jmx
1. Open Inventory App
2. Select Instance tab in top left
3. Select Language drop down and type "spa" for Spanish
4. Select Language drop down and type "spa" for Spanish AND Select Staff suppress and check "Yes"

##### Workflow for inventory_itemSearch.jmx
1. Open Inventory App
2. Select Item tab in top left
3. Select Item status drop down and check "Available" 
4. Uncheck "Available"
5. In same drop down check "In transit"
6. Uncheck "In transit"
7. Select "Suppress from discovery" drop down and check "Yes"
8. Goto items tab and Select Nature of content = Newspaper
9. Select Effective location (item) dropdown and add following locations
    UC/HP/AANet/Intrnet or UC/HP/ASR/ACASA or UC/HP/ASR/ARCHASR or UC/HP/ASR/ASRHP or UC/HP/ASR/Atk or bUC/HP/ASR/GameASR or UC/HP/ASR/HarpASR or UC/HP/ASR/JRLASR or UC/HP/ASR/LawASR
   These locations are from the PTF perf testing environment (database)

##### Workflow for users_search.jmx
1. Open Users App
2. Select Status dropdown
3. Check "active" status
4. Keep scrolling until you see Load More button (behind the scene, a query will be made to backend module by increasing offset)
5. Do point 4 couple of times (page renders very slow)

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-19.1.2
- mod-inventory-14.1.2
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.35.2
##### Frontend:
- folio_inventory-2.0.2

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
/apache-jmeter-5.2.1/bin                                              
▶ sudo ./jmeter.sh -n -t [path_to_project]/perf-testing/workflows-scripts/item-search-filter/users_search.jmx -l [path_to_project]/perf-testing/workflows-scripts/item-search-filter/result.jtl
