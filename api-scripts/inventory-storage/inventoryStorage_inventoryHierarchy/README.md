## Modules required to be enabled as a pre-requisite to run JMeter script:
-mod-inventory-storage-19.4.0
-mod-authtoken-2.5.1
-mod-permissions-5.11.2
-okapi-3.1.2

## Usage
- This is a simple standalone JMX script that invokes the POST /inventory-hierarchy/items-and-holdings API. It uses a list of items from instances.csv 
- Modify credentials.csv to have the correct values before running the script.

- Instances used in instancesID.csv contains more than one holding each.
- There's extra java code inside JMeter script that adding one more instance ID to request body each iteration. As far as it's a simply code and it doesn't includes additional libraries it shouldn't affect a performance of script.