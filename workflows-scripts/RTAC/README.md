## Workflow steps:

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
- mod-circulation-18.0.9
- mod-circulation-storage-11.0.0
- mod-inventory-storage-19.1.2
- mod-inventory-14.1.3
- mod-authtoken-2.4.0"
- mod-permissions-5.9.0
- okapi-2.38.0

- FOLIO release: FameFlower
