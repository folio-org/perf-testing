## Introduction
This is a script to create a Data Import profile "PRF - Create 3" for Data Import: Bib records. It is the same profile as PTF - Create 2.

## Workflow steps
##### Workflow for PTF_Create3.jmx
Describe the workflow that the script models and necessary information about using this JMX file
1. In the Settings -> Data Import
2. The script starts by creating 3 mapping profiles. It picks the first parameter (example: instance.statisticalCode, instance.status, statisticalCodeTypes, callNumberTypes, locations, holdingsType) from the dropdown menu
3. Create 3 action profiles with proper mapping profiles
4. Create a Job Profile with "PTF - Create 3" name

## Usage
- Choose in JMeter script property:
                         HOSTNAME - starting from okapi-
                         tenant - specify tenant
                         password - password to Folio app 
                         username - Folio app username
                         vusers - number of concurrent users
                         rampup - ramp-up time in seconds

