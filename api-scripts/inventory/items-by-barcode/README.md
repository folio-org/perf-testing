## Introduction
This repository contains a template for creating a JMeter test script. Below are placeholders to fill information into this README file. There is a sample JMX script that is set up with
the standard required parameters and values, including those for credentials and a login API call. It also includes the jmeter-supported-data directory to place any data needed at runtime.
There is also a scripts folder to hold any script to be run at runtime or pre/post testing. In addition to these basic folders, teams are welcome to create other folders to support their test
as necessary.

## Workflow steps
##### Workflow for appName_workflowName.jmx
Describe the workflow that this test models and necessary information about using this JMX file
1. 
2. 
3. 

## Modules required to be enabled as a pre-requisite to run JMeter script

FOLIO release: [e.g., Goldenrod]

##### Backend:
Back-end modules and version numbers. e.g.:
- mod-circulation-19.0.9
- okapi-3.1.1
- ...
##### Frontend:
Front-end modules and version numbers. e.g.:
- folio_circulation-3.0.1
- ...

## Usage
- Describe the interaction between the Jmeter test script with other files in this repository, such as data files or scripts
- Modify credentials.csv to have the correct values before running the script.

### Prerequisite:
- Any script to run before or after each test run?