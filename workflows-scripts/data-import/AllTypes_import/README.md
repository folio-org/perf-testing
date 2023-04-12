## Introduction
This is a CREATE import workflow of all 3 Types of Data Import: Bib, Authority, Holdings.

## Workflow steps
##### Workflow for data-import-alltypes-create.jmx
Describe the workflow that this test models and necessary information about using this JMX file
1. Data Import app is already opened
2. Script starts from uploading the record file
3. Choose Data Import Create job profile (profile will be chosen automatically)
4. Run Data Import Create

## Modules required to be enabled as a pre-requisite to run JMeter script
FOLIO release: Orchid general release

##### Backend:
Back-end modules and versions as of the Nolana general release:
- mod-data-import
- mod-source-record-storage
- mod-source-record-manager
- mod-inventory
- mod-inventory-storage
- mod-data-import-cs
- mod-quick-marc
- mod-search

## Usage
- Prepare files with proper naming. Do not use dashes (-) in file names:
                        bib_Create should be included to the file name for MARC BIB Create
                        holdings_Create should be included to the file name for MARC Holdings Create
                        authority_Create should be included to the file name for MARC Authority Create
- Ensure that the environment has proper job profiles.
- Choose in JMeter script property:
                         HOSTNAME - starting from okapi-
                         tenant - specify tenant
                         password - password to Folio app 
                         username - Folio app username
                         DI_VUSERS - number of concurrent users
                         DI_RAMP-UP - ramp-up time in seconds
                         DI_file - All file names separated with "-" for all jobs 
                                                    Example: 1_bib_Create.mrc-1_holdings_Create.mrc (2 jobs will be performed)
                         DI_Pause - pause after each DI job in miliseconds

- before holdings test prepare files properly: 
1. export 1 record file with import profile Default - Create instance and SRS MARC Bib
2. After it completed - copy field 001 from newly created record (from UI) (it should looks like “in00007579903”).
3. Open file that should be exported as marc holding using Marc edit replace all 004 fields with 001 that you have from previous step.
4. On UI go on “”APPS” -> Settings-> Tenant-> locations choose some institution, campus, library and location. Copy code of this location and paste it in part of 852 field in file
