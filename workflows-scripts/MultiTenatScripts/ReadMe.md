##Workflow
Script and supported data for circulation CheckIn - CheckOut workflow for multiple tenants.

##Preparation for run
1. Run Script to cleanup DB before each run.
2. Select all needed data and store them in files. user_barcodes, item_barcode_availiable, item_barcodes_checkedout, servicePoints_Id. 
3. Provide valid username,password,tenant,HOST into credentials.csv.
note: all files need to have unique names to be used in different thread groups. 
note: all CSV Data set configs in jmeter should have Sharing more - current thread group. to prevent data overlapping. 

##To add new tenant to the script. 
1. Copy-paste any thread group and rename it (preferable as a tenant ID). 
2. Be sure that all Module controllers are mapped on needed test fragments.
3. Add new path to each file in .csv data set configs. 