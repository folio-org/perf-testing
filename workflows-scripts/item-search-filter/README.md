## Steps to run JMeter script:
##### Using GUI:
1. Open .jmx file in JMeter IDE
2. Change credentials in jmeter-supported-data\credentials.csv 
_[folio username],[foolio password],[tenantId]_
3. Change hostname in User Defined Variables
4. Click to the play button

##### Using non-GUI:
Navigate to Apache bin folder and run script.
For example:
Workspace/apache-jmeter-5.2.1/bin                                                                                                                                                                                                                            
▶ sudo ./jmeter.sh -n -t /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/users_search.jmx -l /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/result.jtl 
Password:
Creating summariser <summary>
Created the tree successfully using /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/users_search.jmx
Starting standalone test @ Fri Apr 17 14:06:38 EDT 2020 (1587146798332)
Waiting for possible Shutdown/StopTestNow/HeapDump/ThreadDump message on port 4445
summary +     15 in 00:00:23 =    0.7/s Avg:  1482 Min:   160 Max:  1866 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary +     17 in 00:00:30 =    0.6/s Avg:  1765 Min:  1659 Max:  1890 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =     32 in 00:00:53 =    0.6/s Avg:  1632 Min:   160 Max:  1890 Err:     0 (0.00%)
summary +     17 in 00:00:30 =    0.6/s Avg:  1772 Min:  1669 Max:  1910 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =     49 in 00:01:23 =    0.6/s Avg:  1681 Min:   160 Max:  1910 Err:     0 (0.00%)
summary +     16 in 00:00:28 =    0.6/s Avg:  1775 Min:  1663 Max:  1936 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =     65 in 00:01:51 =    0.6/s Avg:  1704 Min:   160 Max:  1936 Err:     0 (0.00%)
summary +     17 in 00:00:30 =    0.6/s Avg:  1765 Min:  1662 Max:  1898 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =     82 in 00:02:21 =    0.6/s Avg:  1716 Min:   160 Max:  1936 Err:     0 (0.00%)
summary +     12 in 00:00:21 =    0.6/s Avg:  1775 Min:  1676 Max:  1950 Err:     0 (0.00%) Active: 0 Started: 1 Finished: 1
summary =     94 in 00:02:43 =    0.6/s Avg:  1724 Min:   160 Max:  1950 Err:     0 (0.00%)
Tidying up ...    @ Fri Apr 17 14:09:21 EDT 2020 (1587146961403)
... end of run
                                                                                                                                                                                                                           
▶ sudo ./jmeter.sh -n -t /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/inventory_instanceSearch.jmx -l /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/result.jtl 
Password:
Creating summariser <summary>
Created the tree successfully using /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/inventory_instanceSearch.jmx
Starting standalone test @ Fri Apr 17 14:11:42 EDT 2020 (1587147102590)
Waiting for possible Shutdown/StopTestNow/HeapDump/ThreadDump message on port 4445
summary =   1301 in 00:00:11 =  123.7/s Avg:   294 Min:    59 Max:  3905 Err:     0 (0.00%)
Tidying up ...    @ Fri Apr 17 14:11:53 EDT 2020 (1587147113568)
... end of run
                                                                                                                                                                                                                           
▶ sudo ./jmeter.sh -n -t /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/inventory_itemSearch.jmx -l /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/result.jtl    
Creating summariser <summary>
Created the tree successfully using /Users/vjavalkar/Workspace/FOLIO/perf-testing/workflows-scripts/item-search-filter/inventory_itemSearch.jmx
Starting standalone test @ Fri Apr 17 14:12:13 EDT 2020 (1587147133568)
Waiting for possible Shutdown/StopTestNow/HeapDump/ThreadDump message on port 4445
summary +    836 in 00:00:16 =   51.3/s Avg:   455 Min:    57 Max:  3345 Err:     0 (0.00%) Active: 30 Started: 30 Finished: 0
summary +    105 in 00:00:30 =    3.5/s Avg:  4355 Min:    80 Max: 25807 Err:     0 (0.00%) Active: 30 Started: 30 Finished: 0
summary =    941 in 00:00:46 =   20.4/s Avg:   890 Min:    57 Max: 25807 Err:     0 (0.00%)
summary +     40 in 00:00:33 =    1.2/s Avg: 28960 Min: 14288 Max: 54170 Err:     0 (0.00%) Active: 10 Started: 30 Finished: 20
summary =    981 in 00:01:19 =   12.5/s Avg:  2034 Min:    57 Max: 54170 Err:     0 (0.00%)
summary +     10 in 00:00:08 =    1.2/s Avg:  9922 Min:  8076 Max: 10884 Err:     0 (0.00%) Active: 0 Started: 30 Finished: 30
summary =    991 in 00:01:27 =   11.4/s Avg:  2114 Min:    57 Max: 54170 Err:     0 (0.00%)
Tidying up ...    @ Fri Apr 17 14:13:40 EDT 2020 (1587147220865)
... end of run

Observations:
Queries:
Get instances by natureOfContentTermIds
GET /instance-storage/instances?query=(languages="spa" and natureOfContentTermIds="ebbbdef1-00e1-428b-bc11-314dc0705074") sortby title&limit=100&offset=0 
Environment - bugfest.folio.ebsco.com
RDS instances size - db.r5.2xlarge
Users - 30 ramping up in 30 seconds. Therefore, 1 user, every 1 second searching inventory instances
Latency - average ~20 seconds

Get instances by effectiveLocationId:
GET /instance-storage/instances?query=(item.effectiveLocationId=("b0237985-87e6-4f9c-b6c2-23ef426f7d03" or "d695b3e4-5bbb-4ab2-b998-6e52cd395d86" or "c9379617-4061-439b-80bd-117abc9f9004" or "e5d578f4-17ce-4c70-b1b5-565f3605e10b" or "f369266a-a209-4e4a-b487-d1acf3ee6857" or "bd90f838-4bc4-4ef0-963b-502210fb5976" or "1d4222af-0994-4f15-bab1-568b2f6d3f40" or "c3dd9997-463b-47e3-958c-2c6fc2775f90" or "38baf4b3-4fe7-47c1-826b-5d35e7b41018")) sortby title&limit=100&offset=0
Environment - bugfest.folio.ebsco.com
RDS instances size - db.r5.2xlarge
Users - 30 ramping up in 30 seconds. Therefore, 1 user, every 1 second searching inventory instances
Latency - average ~9 seconds

Get users by query (slow sql query when getting users total count)
GET /users?limit=30&query=(active="true") sortby personal.lastName personal.firstName
Environment - bugfest.folio.ebsco.com
RDS instances size - db.r5.2xlarge
Users - 1 ramping up in 1 second
Latency - average ~1.7 seconds
I think query is slow to get total user count because UI, waits to load users until we scroll down the page to view more users. That is when a call is made to the backend to get more users using offset in query parameter 
