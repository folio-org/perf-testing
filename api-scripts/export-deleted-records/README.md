## Workflow steps:

##### Workflow for Export_Deleted_Records.jmx
1. Loop by 2000 records through all deleted Authority records in mod-entities-links


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-login:7.12.0
- mod-authtoken:2.16.0
- mod-users:19.3.3
- mod-entities-links:3.1.0
- nginx-okapi:2023.06.14
- okapi:5.3.0



## Usage
- This is a simple standalone JMX script that invokes the GET_authority-storage/authorities API. 
- Modify credentials.csv to have the correct values before running the script.
