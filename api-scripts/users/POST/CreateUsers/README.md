## Introduction
This is an API test for POST /users to create new users. 

## Workflow steps
##### Workflow for appName_workflowName.jmx
N/A.

## Modules required to be enabled as a pre-requisite to run JMeter script

FOLIO release: Lotus

##### Backend:
- mod-users-18.2.0

##### Frontend:
N/A

## Usage
- Modify credentials.csv to have the correct values before running the script.
- Modify patronGroup.csv to have 1 patron group's UUID (in mod_users.groups table) in the desired tenant. Currently it is populated with a value from a PTF database of the tenant fs09000000.

### Prerequisite:
- None

### Post Test Run:
- Run a simple deletion script to delete the records added to restore the table to the state before running the test.

` DELETE FROM <tenantId>_mod_users.users WHERE creation_date > '2022-06-03T00:00:00.000'`

   Change the timestamp to the timestamp when the test started. 