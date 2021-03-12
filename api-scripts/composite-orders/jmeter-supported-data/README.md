## API execution steps:

##### api for POST_CompositeOrders.jmx
1. POST orders/composite-orders

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-orders-11.1.3

- FOLIO release: Honeysuckle hotfix-2

##### Pre-requisite:
Raw composite orders are given - sample compositeOrders100.json

##### Steps to run test:
1. Raw data is given compositeOrders100.json - we have to split each line in this file into separate .json file which is basically a request body for POST /composite-orders
2. Run bash script split-to-multiple_json_files.sh which will generate 100 .json files from the raw data provided. To run bash script, to inside the directory and do `./split-to-multiple_json_files.sh`
3. Save these file in a folder "requestBodyJsonFiles" - this folder is accessed in .jmx file
4. Create a JsonFilename.csv which will hold filenames of .json files created in step 2 and 3 above
5. In .jmx file, in CSV Data config, make sure you have correct filename(JsonFilename.csv)
6. In .jmx, thread group, make sure loop count is set to number of file created in "requestBodyJsonFiles"(100)
7. In .jmx, in POST request body, make sure path and filename is correct
8. Run the JMeter script in carrier-io