## Introduction
This is a scripts to create a Data Import profiles "PRF - Create 3" for Data Import: Bib records. It is the same profile as PTF - Create 2 and profile "PTF-Update Success - 1"

## Workflow steps
##### Workflow for DI_Create_profile.jmx
Describe the workflow that the script models and necessary information about using this JMX file
1. In the Settings -> Data Import
2. The script starts by creating 3 Mapping profiles. It picks the first parameter (example: instance.statisticalCode, instance.status, statisticalCodeTypes, callNumberTypes, locations, holdingsType) from the dropdown menu
3. Create 3 action profiles with proper mapping profiles
4. Create a Job Profile with "PTF - Create 3" name

##### Workflow for DI_update_profile.jmx
Describe the workflow that the script models and necessary information about using this JMX file
1. In the Settings -> Data Import
2. The script starts by creating 3 mapping profiles. It picks the first parameter (example: instance.statisticalCode, instance.status, statisticalCodeTypes, callNumberTypes, locations, holdingsType) from the dropdown menu
3. Create 3 action profiles with proper mapping profiles
4. Create 3 match profiles
5. Create a Job Profile with "PTF - Updates Success - 1(test)" name

## Usage
- Choose in JMeter script property:
                         HOSTNAME - starting from okapi-
                         tenant - specify tenant
                         password - password to Folio app 
                         username - Folio app username

