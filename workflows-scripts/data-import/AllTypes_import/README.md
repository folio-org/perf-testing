## Introduction
This is a CREATE import workflow of all 3 Types of Data Import: Bib, Authority, Holdings.

## Workflow steps
##### Workflow for data-import-alltypes-create.jmx
Describe the workflow that this test models and necessary information about using this JMX file
1. Go to Data Import app
2. Click to to upload the record file
3. Choose Data Import Create job profile
4. Run Data Import Create

## Modules required to be enabled as a pre-requisite to run JMeter script
FOLIO release: Nolana general release

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
- Modify credentials.csv to have the correct values before running the script.
- Ensure that the environment has proper job profiles.
- Choose in JMeter script property:
                         HOSTNAME starting from okapi-
                         importType from bib, authority, holdings
                         profile_name: PTF - Create 2, Default - Create SRS MARC Authority, Default - Create instance and SRS MARC Bib etc.
                         file_size for bib - 1k,2k,5k,10k,25k,50k,100k,500k,all(to run jobs for all record files one by one with 5 min interval)
                                     authority - 1k,5k,10k,25k,50k,all(to run jobs for all record files one by one with 5 min interval)
                                     holdings - 1k,5k,10k,80k,all(to run jobs for all record files one by one with 5 min interval) 
                        test_count for test with parameters all to run all:
                                    - bib tests set-8 or if you need only the first few tests to be run decrease the number of test_count, example: set test_count to 3 for bib and it will be 1k, 2k, 5k tested
                                    - authority tests set-5
                                    - holdings tests set-4
                                if you need 1 test to be run set test_count - 1 for any of the choosen file_size
- before holdings test prepare files properly: 
1. export 1 record file with import profile Default - Create instance and SRS MARC Bib
2. After it completed - copy field 001 from newly created record (from UI) (it should looks like “in00007579903”).
3. Open file that should be exported as marc holding using Marc edit replace all 004 fields with 001 that you have from previous step.
4. On UI go on “”APPS” -> Settings-> Tenant-> locations choose some institution, campus, library and location. Copy code of this location and paste it in part of 852 field in file
