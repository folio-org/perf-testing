### Pre-requisite:
#### Generate data:
1. Open Inventory App -> Instance tab -> select query and type for example: "source= marc"
2. On top right select "Save Instance UUIDs"
3. csv file will be downloaded
4. Rename it and place it in data-export/jmeter-supported-data

#### Workflow steps:
##### In UI:
1. Open Data export App
2. On top left, choose .csv file with record IDS (browse to location where instance-record-ids.csv exists)

After specifying csv file, UI will return. Then, asynchronously POST data-export/export request will start a task  which calls mod-source-record-storage module

To mimics workflow in UI, following calls need to be made to backend in dataExport_exportMARCBibRecords.jmx as below:
1. POST data-export/fileDefinitions 
request
  filename and size
response
 returns filename and metadata
2. POST data-export/fileDefinitions/${fileDefinitionId}/upload
request
  file content as a Stream
response
  file attributes json
3. POST data-export/export
request
  file definition and job profile
response
  returns 204 on success and asynchronously makes a call to mod-source-record-storage
4. Loop over GET data-export/jobExecutions?query=id==${jobExecutionId} endpoint until job status is SUCCESS otherwise return
request
  empty
response
  job execution details with respective jobExecutionId with status

To measure slowness, look for Exporting MARC Bib records workflow Transaction average response time in Aggregate Report


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-source-record-storage-3.1.4
- mod-data-export-1.1.1
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.38.0
##### Frontend:
- folio_stripes-data-transfer-components-1.0.1

- FOLIO release: FameFlower
