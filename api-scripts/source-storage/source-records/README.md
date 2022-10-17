## Introduction
This JMeter test script tests calling GET /source-storage/source-records API

## Workflow steps
##### Workflow for source-storage_source-records.jmx
N/A

## Modules required to be enabled as a pre-requisite to run JMeter script
FOLIO release: Juniper/Kiwi and above

##### Backend:
Back-end modules and version numbers. e.g.:
- mod-source-record-storage-5.2.5 (Kiwi's)

##### Frontend:
N/A

## Usage
- A simple API call that requires a list of Ids (UUIDs) from the <tenantId>_mod_source_record_storage.snapshots_lb table. 

### Prerequisite:
- To run this script on a specific environment, need to populate source-records-snapshot-Ids.csv with the environment's snapshots_lb's IDs first. The attached source-records-snapshot-Ids.csv is filled with Ids from PTF's Kiwi environment