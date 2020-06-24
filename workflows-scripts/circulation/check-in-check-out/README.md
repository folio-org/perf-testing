##Artifacts and usage
This package contains scripts to preload the database with loans and 
requests and to restore the database after running the test, as well as scripts used during test execution.
##Scripts
### Runtime script
- BranchSelectorRandomizerScript.gvy: This script is used in the test. It randomizes the check in and check out requests based on a predefined percentage of checking-in or -out.
### Non-Runtime scripts
- circ-data-load.sh: loads a 5000+ loans and 3000+ requests to mimic an inventory that has loans and requests. The data should be in the same directory as the script. In the github repo, data is in the circulation-seed-data.zip file.
- checkin-checkout-db-restore.sql: restores the DB to its original state. This script should be run after each test run to ensure that subsequent test runs have the same starting point.  This script truncates all loans and requests and their associated tables, and also restores all the inventory items' status to "Available".

These two scripts are to be run manually on the box that could connect to the database. 
  
##jmeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- Available.csv: a list barcodes that have Available status
- checked_out.csv: a list of barcodes that although have Avaialble status may be considered as "checked out" so that they can be used in the check-in calls.
- credentials.csv: a file to specify credentials for the tennant being tested.
- user_barcodes.scv: a list of barcodes of actual patronIDs that will be used to check in/out with.

### Non-runtime Data
- circulation-seed-data.zip: This zip file is used by the circ-data-load.sh script. It contains seed data for requests, loans, and related loans/requests data. It needs to be unpacked and the files are placed in the same directory as the circ-data-load.sh script.