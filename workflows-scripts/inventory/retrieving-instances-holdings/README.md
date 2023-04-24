## Workflow steps:

##### inventory_retrievingInstancesHoldings.jmx
1. GET /source-storage/source-records?instanceHrid=<InstanceUUID>
2. GET /holdings-storage/holdings?query=instanceId==<insanceUUID>
## Modules required(minimum required versions) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-25.0.4
- mod-inventory-19.0.2
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- mod-source-record-storage-5.5.2
- okapi-4.14.7

- FOLIO release: Nolana
###### Csv data config files
They are used for test parameterization, for creating different data sets for different users in the same test script.
- credentials.csv (contains username,password,tenant, they are needed for login)
- instance_ids.csv contains instance ids