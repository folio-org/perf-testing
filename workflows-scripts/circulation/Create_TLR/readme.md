## Test Execution Steps
1. Make sure that the DB is clean by running checkin-checkout-db-restore.sql
2. Add seed data to mimic a database that already has loans and requests by running circ-data-load.sh
3. Run the test
(On carrier-io Jenkins job, specify the test name as folio)
4. Clean up the DB afterward by running checkin-checkout-db-restore.sql to restore the database state.

## Artifacts and Usage
The script is used to create title-level requests for list of items. There are 6000 items in file, for each item 10 TLR are created. File with items contains only items of those instances that have 1 item.
The package contains scripts to preload the database with loans and 
requests and to restore the database after running the test, as well as scripts used during test execution.
## Scripts

### Non-Runtime Scripts
- circ-data-load.sh loads a 5000+ loans and 3000+ requests to mimic an inventory that has loans and requests. The data should be in the same directory as the script. In the github repo, data is in the circulation-seed-data.zip file.
- checkin-checkout-db-restore.sql restores the DB to its original state. This script should be run after each test run to ensure that subsequent test runs have the same starting point.  This script truncates all loans and requests and their associated tables, and also restores all the inventory items' status to Available.
These two scripts are to be run manually on the box that could connect to the database. 

To run the data load script
1. Go to an AWS EC2 jump box that's in the same environment as that DB.
2. Download the folder that contains the seed data (circulation-seed-data.zip). Unzip it.
3. Navigate to the directory that contains the seed data files
4. Create a database configuration data that the script will need. Add the following JSON to the file and fill in the values
`{
     database,
     username,
     password,
     host,
     port
 }`
5. Save it with the name db.conf
6. Execute the script as follows .circ-data-load.sh db.conf tenant-ID

To run the database restore script
1. Go to an AWS EC2 jump box that's in the same environment as that DB.
2. Execute  psql -f checkin-checkout-db-restore.sql -a --echo-all -h database-host-name -U db-username -d db-name
3. Enter password when prompted
  
## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- credentials.csv a file to specify credentials for the tennant being tested.
- items.csv a list of item barcodes for instances having 1 item.
- service_point - a list of points for check-out.
- user_barcodes.scv a list of barcodes of actual patronIDs that will be used to check in with.
- user_barcodes2.scv a list of barcodes of actual patronIDs that will be used to create TLR-requests.

### Non-runtime Data
- circulation-seed-data.zip This zip file is used by the circ-data-load.sh script. It contains seed data for requests, loans, and related loansrequests data. It needs to be unpacked and the files are placed in the same directory as the circ-data-load.sh script.

## Relevant Modules Versions (Nolana release)

- mod-inventory-19.0.2	
- mod-inventory-storage-25.0.3	
- okapi-4.14.7
- mod-feesfines-18.1.1
- mod-patron-blocks-1.7.1
- mod-pubsub-2.7.0
- mod-authtoken-2.12.0
- mod-circulation-storage-15.0.2
- mod-circulation-23.3.2
- mod-configuration-5.9.0
- mod-users-19.0.0
- mod-remote-storage-1.7.1	