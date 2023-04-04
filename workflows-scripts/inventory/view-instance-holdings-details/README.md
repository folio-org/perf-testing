## Workflow steps:

##### inventory_viewHoldingsInstanceDetails.jmx The script was created to get instance and holdings details for the specific ID
1. Go to Inventory App
2. Get a list of IDs from the request /inventory/instances?offset=0&limit=1000 with metadata.updatedDate>="<updatedDate>" inside. Define random id from the list
3. Use found id in two next requests to obtain instance and holdings details.

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