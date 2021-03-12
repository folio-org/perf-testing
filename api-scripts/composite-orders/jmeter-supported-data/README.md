## API execution steps:

##### api for POST_CompositeOrders.jmx
1. POST orders/composite-orders

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-orders-11.1.3

- FOLIO release: Honeysuckle hotfix-2

##### Pre-requisite:
Raw composite orders are given - sample compositeOrders.json

##### Steps to run test:
1. Raw data is given compositeOrders.json - we have to split each line in this file into separate .json file which is basically a request body for POST /composite-orders
2. Run bash script split-to-multiple_json_files.sh which will generate `x` number .json files depending on total number of lines in the raw data. Run the bash script `./split-to-multiple_json_files.sh` from inside the directory
3. Create a new JsonFilename.csv which will hold filenames of .json files created in step 2 above
4. In .jmx file, in CSV Data config, make sure you have correct filename(for example JsonFilename.csv)
5. In .jmx file, in thread group, make sure loop count is set to number of file created in "requestBodyJsonFiles"(for example: 100)
6. In .jmx file, in POST request body, make sure path and filename is correct
7. Run the JMeter script

#### References:
https://devqa.io/jmeter-send-json-file-as-request-in-body/