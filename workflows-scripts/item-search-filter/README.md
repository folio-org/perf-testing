## Workflow steps:
##### Workflow for inventory_instanceSearch.jmx
1 Open Inventory App
2 Select Instance tab in top left
3 Select Language drop down and type "spa" for Spanish
4 Select Language drop down and type "spa" for Spanish AND Select Staff suppress and check "Yes"

##### Workflow for inventory_itemSearch.jmx
1 Open Inventory App
2 Select Item tab in top left
3 Select Item status drop down and check "Available" 
4 Uncheck "Available"
5 In same drop down check "In transit"
6 Uncheck "In transit"
7 Select "Suppress from discovery" drop down and check "Yes"
8 Goto items tab and Select Nature of content = Newspaper
9 Select Effective location (item) dropdown and add following locations with ids
    "b0237985-87e6-4f9c-b6c2-23ef426f7d03" or "d695b3e4-5bbb-4ab2-b998-6e52cd395d86" or "c9379617-4061-439b-80bd-117abc9f9004" or "e5d578f4-17ce-4c70-b1b5-565f3605e10b" or "f369266a-a209-4e4a-b487-d1acf3ee6857" or "bd90f838-4bc4-4ef0-963b-502210fb5976" or "1d4222af-0994-4f15-bab1-568b2f6d3f40" or "c3dd9997-463b-47e3-958c-2c6fc2775f90" or "38baf4b3-4fe7-47c1-826b-5d35e7b41018"

##### Workflow for users_search.jmx
1 Open Users App
2 Select Status dropdown
3 Check "active" status
4 Keep scrolling until you see Load More button (behind the scene, a query will be made to backend module by increasing offset)
5 Do point 4 couple of times (page renders very slow)


## Steps to run JMeter script:
##### Using GUI:
1. Open .jmx file in JMeter IDE
2. Change credentials in jmeter-supported-data\credentials.csv 
_[folio username],[foolio password],[tenantId]_
3. Change hostname in User Defined Variables
4. Click to the play button

##### Using non-GUI:
Navigate to Apache bin folder and run script.
For example:
Workspace/apache-jmeter-5.2.1/bin                                                                                                                                                                                                                            
▶ sudo ./jmeter.sh -n -t /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/users_search.jmx -l /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/result.jtl

## Observations:
Queries:
Get instances by natureOfContentTermIds
GET /instance-storage/instances?query=(languages="spa" and natureOfContentTermIds="ebbbdef1-00e1-428b-bc11-314dc0705074") sortby title&limit=100&offset=0 
Environment - bugfest.folio.ebsco.com
RDS instances size - db.r5.2xlarge
Users - 30 ramping up in 30 seconds. Therefore, 1 user, every 1 second searching inventory instances
Latency - average ~20 seconds

Get instances by effectiveLocationId:
GET /instance-storage/instances?query=(item.effectiveLocationId=("b0237985-87e6-4f9c-b6c2-23ef426f7d03" or "d695b3e4-5bbb-4ab2-b998-6e52cd395d86" or "c9379617-4061-439b-80bd-117abc9f9004" or "e5d578f4-17ce-4c70-b1b5-565f3605e10b" or "f369266a-a209-4e4a-b487-d1acf3ee6857" or "bd90f838-4bc4-4ef0-963b-502210fb5976" or "1d4222af-0994-4f15-bab1-568b2f6d3f40" or "c3dd9997-463b-47e3-958c-2c6fc2775f90" or "38baf4b3-4fe7-47c1-826b-5d35e7b41018")) sortby title&limit=100&offset=0
Environment - bugfest.folio.ebsco.com
RDS instances size - db.r5.2xlarge
Users - 30 ramping up in 30 seconds. Therefore, 1 user, every 1 second searching inventory instances
Latency - average ~9 seconds

Get users by query (slow sql query when getting users total count)
GET /users?limit=30&query=(active="true") sortby personal.lastName personal.firstName
Environment - bugfest.folio.ebsco.com
RDS instances size - db.r5.2xlarge
Users - 1 ramping up in 1 second
Latency - average ~1.7 seconds
I think query is slow to get total user count because UI, waits to load users until we scroll down the page to view more users. That is when a call is made to the backend to get more users using offset in query parameter 
