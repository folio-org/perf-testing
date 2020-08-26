## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-circulation-19.0.9
- mod-circulation-storage-12.0.1
- mod-inventory-16.0.1
- mod-inventory-storage-19.0.9
- mod-authtoken-2.5.1
- mod-permissions-5.11.2
- okapi-3.1.1
##### Frontend:
- folio_circulation-3.0.1
- folio-inventory-4.0.3
- FOLIO release: Goldenrod


## Usage
- This is a simple standalone JMX script that invokes the GET circulation/loans API. It uses a list of items from ItemID.csv.
- Modify credentials.csv to have the correct values before running the script.
### Prerequisite:
- Before running this script and after each test run, need to restore the database state. See 
https://github.com/folio-org/perf-testing/tree/master/workflows-scripts/circulation/check-in-check-out for more information on how to 
run the scripts to restore the database and load circulation data.