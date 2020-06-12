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
- users.csv <br/> 
`SELECT us.jsonb->>'id' FROM fs09000000_mod_users.users as us WHERE us.jsonb->>'id' NOT IN (SELECT req.jsonb->>'requesterId'
	FROM fs09000000_mod_circulation_storage.request as req GROUP BY jsonb->>'requesterId');
`

- instances_without_requests.csv <br/>
`SELECT distinct inst.id
	FROM fs09000000_mod_inventory_storage.instance as inst, fs09000000_mod_inventory_storage.holdings_record as hr,
	fs09000000_mod_inventory_storage.item as it WHERE inst.id=hr.instanceid AND hr.id=it.holdingsrecordid
	AND it.jsonb->>'id' NOT IN (SELECT req.jsonb->>'itemId'
	FROM fs09000000_mod_circulation_storage.request as req GROUP BY jsonb->>'itemId');
`
- service_points.csv <br/>
they are received on UI

## How does the test work?
The test contains 4 thread groups:
- Login - for identification and authentication, it is executed only 1 time
- Clean - for cleaning if an user has already created a request for an instance. It is turned off by default(The loop count = 0). To turn on the clean, need to change the loop count
- Place an instance-level request - the api test which is tested 
- Delete created requests - for deleting all created requests which have been created by the "Place an instance-level request" thread group. By default, it is turned on. It can be turned off by changing loop count to 0. 