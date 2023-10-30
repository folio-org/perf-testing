## Workflow steps:

##### API for oai_pmh_IH.jmx
Incremental harvesting by dates range

1. /oai?verb=ListRecords&metadataPrefix=marc21_withholdings&apikey=<apiKey>&from=<start-date>&until=<end-date>
2. /oai/records?verb=ListRecords&apikey=${APIKey}&resumptionToken=${resumptionToken}


##### oai_pmh_IH.jmx Variables
1. Hostname
2. API_KEY
3. fromTime
4. untilTime
5. metadataPrefix

##### In loop counter you should enter the number of loops to harvest the required number of records
10k-98; 
25k-250; 
50k-499; 
500K-5000; 
1mln-10000;
One request according to the oai-mph module setting extracrt 100 records.

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-oai-pmh-3.11.1
- mod-edge-oai-pmh-2.6.0
- mod-inventory-storage:26.1.0
- mod-source-record-storage:5.7.0

- FOLIO release: Orchid
