## API test:
EDS programmatically calls mod-patron using the API - 
`POST /patron/account/{id}/instance/{instanceId}/hold`

An example of instance-level request to mod-patron:

`{
    "item": {
	    "instanceId": "c2063f7c-245a-4c24-b643-67fea831ebcc"
	},
    "requestDate": "2020-06-01T18:51:24.000+0000",
    "pickupLocationId": "7068e104-aa14-4f30-a8bf-71f71cc15e07"
}`
 


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-patron-4.2.0-SNAPSHOT
- mod-circulation-18.0.9
- mod-circulation-storage-11.0.0
- mod-inventory-storage-19.1.2
- mod-inventory-14.1.3
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.38.0

- FOLIO release: FameFlower

#Sql queries from jmeter-supported-data folder
The ids of users and the ids of instances have been pulled which don't have requests in order to not clean requests which have already existed

- user_ids_without_requests.csv (the users' ids have been cut to 10000 records, that's enough to run a 30-min test with 20 users)<br/> 
`SELECT us.jsonb->>'id' FROM fs09000000_mod_users.users as us WHERE us.jsonb->>'id' NOT IN (SELECT req.jsonb->>'requesterId'
	FROM fs09000000_mod_circulation_storage.request as req GROUP BY jsonb->>'requesterId');
`

- instances_without_requests.csv (the instances' ids have been cut to 10000 records, that's enough to run a 30-min test with 20 users)<br/>
`SELECT distinct inst.id
	FROM fs09000000_mod_inventory_storage.instance as inst, fs09000000_mod_inventory_storage.holdings_record as hr,
	fs09000000_mod_inventory_storage.item as it WHERE inst.id=hr.instanceid AND hr.id=it.holdingsrecordid
	AND it.jsonb->>'id' NOT IN (SELECT req.jsonb->>'itemId'
	FROM fs09000000_mod_circulation_storage.request as req GROUP BY jsonb->>'itemId');
`

- service_points.csv <br/>
they are received on UI

- delete_requests.sql (it is a sql script to clean the requests by users' ids)

## Thread groups:
The test contains of 2 thread groups:
- Login - for identification and authentication, it is executed only 1 time
- Place an instance-level request - the api test which is tested 

## Before the test execution:
need to clean the requests by users' ids

- copy the file delete_requests.sql from the jmeter-supported-data folder to carrio-io. WinSCP or other applications can be used
- open carrio-io (using putty or others applications) and run the command
`psql -h ${host} -d ${database} -U ${username} -a -f delete_requests.sql`
