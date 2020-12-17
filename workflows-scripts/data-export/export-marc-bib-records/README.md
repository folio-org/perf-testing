### Pre-requisite:
#### Generate data:
- Approach 1:
1. Open Inventory App -> Instance tab -> select query and type for example: "source= marc"
2. On top right select "Save Instance UUIDs"
3. csv file will be downloaded
4. Rename it and place it in data-export/jmeter-supported-data
- Approach 2:
1. Log into database
2. Run Postgresql query to generate ids 
For example ```	SELECT id FROM fs09000000_mod_inventory_storage.instance where jsonb->>'source'='MARC' LIMIT 40;```

#### Workflow steps:
##### In UI:
1. Open Data export App
2. On top left, choose .csv file with record IDS (browse to location where instance-record-ids.csv exists)

After specifying csv file, UI will return. Then, asynchronously POST data-export/export request will start a task  which calls mod-source-record-storage module

To mimics workflow in UI, following calls need to be made to backend in dataExport_exportMARCBibRecords.jmx as below:
1. POST data-export/file-definitions 
request
  filename and size
response
 returns filename and metadata
2. POST data-export/file-definitions/${fileDefinitionId}/upload
request
  file content as a Stream
response
  file attributes json
3. POST data-export/export
request
  file definition and job profile
response
  returns 204 on success and asynchronously makes a call to mod-source-record-storage
4. Loop over GET data-export/job-executions?query=id==${jobExecutionId} endpoint until job status is SUCCESS otherwise return
request
  empty
response
  job execution details with respective jobExecutionId with status

To measure slowness, look for Exporting MARC Bib records workflow Transaction average response time in Aggregate Report


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-source-record-storage
- mod-data-export
- mod-authtoken
- mod-permissions
- okapi
##### Frontend:
- folio_data-export