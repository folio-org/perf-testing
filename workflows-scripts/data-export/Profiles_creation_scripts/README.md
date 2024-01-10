## Introduction
This is a scripts to create a Data Export profile "Export for Data Import updates" for Data Import with profile "PTF-Update Success - 1"

## Workflow steps
##### Workflow for DE_for_DI_updates.jmx
Describe the workflow that the script models and necessary information about using this JMX file
1. In the Settings -> Data Export
2. The script starts by creating Mapping profile. "MARC Bib with Holdings and Item HRIDs-1"
4. Create a Job Profile with "Export for Data Import updates(test)" name

## Usage
- Choose in JMeter script property:
                         HOSTNAME - starting from okapi-
                         tenant - specify tenant
                         password - password to Folio app 
                         username - Folio app username

