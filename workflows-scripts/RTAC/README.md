## Workflow steps:

##### Workflow for mod_rtac_listInstanceIds.jmx
This script makes call to new mod-rtac API POST /rtac-batch

##### Workflow for edge_rtac_listInstanceIds.jmx
This script makes call to new edge-rtac API GET /rtac?instanceIds=id1,id2,id3,id4,id5,id6,id7,id8,id9,id10&apikey={API_KEY}&fullPeriodicals=true

##### Workflow for mod-rtac_allBackendApiCalls.jmx
This script mimics calls made by /rtac/{instance} API endpoint which is 
For 1 instance -> many holdings -> each holding -> many items -> each item -> many loans

##### Workflow for mod_rtacTestPlan.jmx
This script makes direct call to /rtac/{instance} API endpoint

SQL query to get all instances whose total holdings record count > 300:
```
select DISTINCT hr1.instanceid from fs09000000_mod_inventory_storage.holdings_record hr1
where (select count(*) from fs09000000_mod_inventory_storage.holdings_record hr2
where hr2.instanceid = hr1.instanceid group by hr2.instanceid) > 300;
```

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-circulation
- mod-circulation-storage
- mod-inventory-storage
- mod-inventory
- mod-authtoken
- mod-permissions
- okapi
- mod-rtac
- edge-rtac
