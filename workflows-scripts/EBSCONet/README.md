## Workflow steps:

##### Script design
Script consists of three thread groups:
- Login Thread Group
- EBSCONET Okapi
- edgeebsconet Edge

Login Thread Group and EBSCONET Okapi thread group represents calls that is going through okapi.

edgeebsconet Edge thread group represents calls that is going through edge endpoint with API token

to use different approach please disable thread groups that is not needed. 


##### Workflow for EBSCONET.jmx
[get] /ebsconet/orders/order-lines/${polineNumber}

[put] /ebsconet/orders/order-lines/${polineNumber}

with body:
```{
    "currency": "USD",
    "fundCode": "NEW2023",
    "poLineNumber": "${polineNumber}",
    "quantity": 1,
    "unitPrice": 1.0,
    "vendor": "ZHONEWAX$%",
    "vendorAccountNumber": "libraryorders@library.tam",
    "vendorReferenceNumbers": [],
    "workflowStatus": "Open"
}
```
##### Additional info:
To run test
- populate credentials.csv with valid username,password,tenantId
- populate POLINES.csv with valid POline id's
- set variables values in "User Defined Variables"

script will automatically stop when threads will reach the end of POLINES.csv file, which will mean that all POLines being renewed 


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-organizations 1.6.0
- mod-organizations-storage 4.4.0
- mod-finance 4.6.2
- mod-finance-storage 8.3.1
- nginx-edge nginx-edge:2022.03.02
- mod-ebsconet 1.4.0
- nginx-okapi nginx-okapi:2022.03.02
- mod-orders 12.5.4 
- mod-orders-storage 13.4.0
- okapi 4.14.7
- mod-mod-notes 4.0.0
- mod-configuration 5.9.0
- edge-orders 2.7.0


- FOLIO release: Nolana

