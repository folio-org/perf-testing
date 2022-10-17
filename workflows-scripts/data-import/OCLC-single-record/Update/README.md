## Introduction
This is the UPDATE import workflow that creates a single record (instance and SRS) from the metadata obtained by passing in an OCLC nunber. The API that is responsible for most of this workflow is 
/copycat/imports. It looks up the record from OCL with the OCLC number being passed in by calling OCLC's z39.50 service, whose connection information is found in the profile defined in Inventory settings. The profile's UUID is also the other piece of data that is being passed into the payload. The API 
also calls the DI module to queue an import job and waits for a predefined number of seconds (5) to poll the DI modules again to see when the job is finished.
The workflow that is being modelled here picks up on the step of the user has been on the inventory app, chose an instance, and clicks the "Overlay source bibliographic record" button to start the import.

## Workflow steps
##### Workflow for inventory_oclcUpdateSingleRecord.jmx
Describe the workflow that this test models and necessary information about using this JMX file
0 (Prerequisite). In the inventory app, select and click on an instance.
1. Click on Actions on the second pane
2. Select "Overlay source bibliographic record"
3. Choose the OCLC Worldcat profile
4. Add the OCLC number
5. Hit Import  (arguably the only action that this JMeter test script models is pressing the Import button because it is when the user actually starts waiting for the import to complete)

## Modules required to be enabled as a pre-requisite to run JMeter script
FOLIO release: Kiwi general release

##### Backend:
Back-end modules and versions as of the Kiwi general release:
- mod-copycat-1.1.1
- mod-source-record-storage-5.2.5
- mod-source-record-manager-3.2.6
- mod-inventory-18.0.4
- mod-inventory-storage-22.0.2

##### Frontend:
Front-end modules and version numbers:
- folio_inventory-8.0.2

## Usage
- Modify credentials.csv to have the correct values before running the script. Also, the fourth value in this file (unlike in other workflow tests) is the UUID of the user we're logging in with.
- Add a valid UUID of the z39.50 profile (under Inventory settings) to the profile "profile_id".
- OCLC numbers are populated and checked into this repo under the file oclc_numbers.csv
- instance_Ids.csv contains the Instance IDs in the environment that has holdings. Attached are values from kcp1. Note that for updates to run, we need to pre-select an instance for it to update, therefore we need to have a list of instance IDs in our test setup.

### Prerequisite:
- Go to Settings -> Inventory -> z39.50 targe tprofiles.  If the profile "OCLC WorldCat" isn't there. Create one by copying over the values from any of the reference environment, including Bugfest, and enable it.
Jog down the UUID of this profile and copy it into the file profile_id.csv in the directory jmeter-supported-data.
- To populate the instance_ids.csv, execute the following query:
  select instanceId from <tenantId>_mod_inventory_storage.holdings_record  order by creation_date desc limit 3000