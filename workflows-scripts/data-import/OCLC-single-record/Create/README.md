## Introduction
This is a CREATE import workflow that creates a single record (instance and SRS) from the metadata obtained by passing in an OCLC nunber. The API that is responsible for most of this workflow is 
/copycat/imports. It looks up the record from OCL with the OCLC number being passed in by calling OCLC's z39.50 service, whose connection information is found in the profile defined in Inventory settings. The profile's UUID is also the other piece of data that is being passed into the payload. The API 
also calls the DI module to queue an import job and waits for a predefined number of seconds (5) to poll the DI modules again to see when the job is finished.
The workflow that is being modelled here picks up on the step of the user has been on the inventory app and clicks the the "Import" button to start the import.

## Workflow steps
##### Workflow for inventory_oclcCreateSingleRecord.jmx
Describe the workflow that this test models and necessary information about using this JMX file
1. Go to Inventory app
2. Click on Actions on the second pane
3. Select Import
4. Choose the OCLC Worldcat profile
5. Add the OCLC number
6. Hit Import (Arguably this is the only step that is being modelled because all the APIs that are in the script are called after hitting the <import> button)

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

### Prerequisite:
- Go to Settings -> Inventory -> z39.50 targe tprofiles.  If the profile "OCLC WorldCat" isn't there. Create one by copying over the values from any of the reference environment, including Bugfest, and enable it.
Jog down the UUID of this profile and copy it into the file profile_id.csv in the directory jmeter-supported-data.