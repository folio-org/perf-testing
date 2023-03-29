## Workflow steps:

##### inventory_viewBibsSource.jmx
1. Go to Inventory App
2. On the Left Search & Filter panel, make sure the following are clicked "Search", "Instance"
3. Enter a keyword to search with
4. When the search result list appears in the middle pane, click on a title link. (The title's detailed record will be displayed on the third panel.)
5. On the record's detail panel, click on Actions -> View Source to bring up the MARC tag table.
6. Note that steps 4-5 are the workflow steps, as the prior steps belong to the search workflow. For now we do not need to record the searching steps. Repeat steps 4-5 by clicking other records in the result list to view details.
## Modules required(minimum required versions) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-25.0.4
- mod-inventory-19.0.2
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- mod-source-record-storage-5.5.2
- okapi-4.14.7
##### Frontend:
- folio_inventory-9.2.8

- FOLIO release: Nolana
###### Csv data config files
They are used for test parameterization, for creating different data sets for different users in the same test script.
- credentials.csv (contains username,password,tenant, they are needed for login)
- keywords.csv (contains keyword) in this case it is Instance keyword you can generate this file using scripts/selectKeyWords.sql