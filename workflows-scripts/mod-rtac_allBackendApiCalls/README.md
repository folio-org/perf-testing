# RTAC performance testing

This workflow has been created to test edge rtac for lookup of an instance with hundreds of associated copies. 
RTAC was reported as slow by Chalmers with EDS timing out when making this request.
Associated Rally and Jira Issues
https://rally1.rallydev.com/#/79944863724d/detail/userstory/354213029256?fdp=true
https://issues.folio.org/browse/EDGRTAC-19 

## Environment Setup
CAP4 environment in integration was used for testing. The following was added for these tests:
- Created a separate test tenant fs08000002 (to avoid conflict with carrier io testing)
- Tenant should ce created with default reference data (default types are referenced from test data records)
- added admin user with the following added permissions required for the setup and execution of the test

```
"inventory-storage.holdings.item.post",
"inventory-storage.instances.item.post",
"inventory-storage.items.item.post",
"inventory-storage.material-types.item.put",
"inventory-storage.material-types.item.post",
"inventory-storage.all",
"rtac.holdings.item.get",
"inventory.instances.item.get",
"perms.users.get",
"perms.users.item.post",
"perms.users.item.post",
"circulation.loans.collection.get",
"inventory.items.collection.get"
```

Permissions can be added by adding to the folio_admin permissions set -- adjusting script - db-admin.sh - such as
https://github.com/EBSCOIS/fse.hosting.infrastructure/blob/master/scripts/folio_scripts/db-admin.sh

or
By issuing a POST request (such as the following) to add needed permissions

```
POST https://okapi-cap4-us-east-1.int.aws.folio.org/perms/users/d916e883-f8f1-4188-bc1d-f0dce1511b50/permissions?indexField=userId

{
	"permissionName" : "circulation.loans.collection.get"
}
```


## Test Data Setup

Folder test-data contains setup of test data for an instance in inventory having a large (318) number of asscociated items.

Test data setup used sample data load for mod-inventory-storage as a model for data loading
-- https://github.com/folio-org/mod-inventory-storage/tree/master/sample-data

To set up needed test data:

Update test-data/import.sh -- add values for ADD_TENANT, ADD_TOKEN and ADD_OKAPI_ADDRESS

Execute ./import.sh to add required records to inventory for the tests
- TENANT_mod_inventory_storage.instance - 1
- TENANT_mod_inventory_storage.holdings_record - 2 records
- TENANT_mod_inventory_storage.item - 318 records

Note - sample-read-item.sh script can be used to read items from an existing environment. Creates folder of files which can be used to populate items in a test environment.

## JMeter Tests

Folder jmeter-tests contains JMeter tests which were run in carrier io performance environment.
Initially a test which calls edge-rtac was used
Revised to a test which calls mod-rtac
Revised to a test which calls the individual modules that mod-rtac calls (mod-inventory, mod-inventory-storage, mod-circulation)

mod-rtacTextPlan_Modules.jmx -- calls underlying modules for a single instance
Requires setup - User Defined Variables for 
- tenant
- user
- password
- host
- protocol
- instance

mod-rtacTextPlan.jmx - calls mod-rtac for a single instance - requires same setup of user defined variables in test


## Running the Tests in carrier io environment

Sample command for running Jmeter tests:

```
docker run --rm -u 0:0 \
     -v /Users/cgodfrey/spitfire/checkouts/fse.hosting.carrier-io/workflows/RTAC/jmeter-tests/:/mnt/jmeter/ \
     -e "loki_host=http://ec2-54-165-58-65.compute-1.amazonaws.com" \
     -e galloper_url=http://ec2-54-165-58-65.compute-1.amazonaws.com \
     -e bucket=tests \
     -e additional_files='{"tests/InfluxBackendListenerClient-1.1.jar": "/jmeter/apache-jmeter-5.0/lib/ext/InfluxBackendListenerClient.jar"}' \
     getcarrier/perfmeter:latest \
     -n -t /mnt/jmeter/mod_rtacTestPlan.jmx -JDURATION=1200 -Jtest_name=mod_rtacTestPlan -Jtest.type=baseline -Jenv.type=mod_rtac -JVUSERS=1 -JRAMP_UP=1 -Jinflux.host=ec2-54-165-58-65.compute-1.amazonaws.com -JLOOP_COUNT=100 -JP_PROTOCOL=https -JP_HOST=edge-cap4-us-east-1.int.aws.folio.org -JTPUT_PERIOD=12

```

Sample run with output

```
docker run --rm -u 0:0 \
>      -v /Users/cgodfrey/apache-jmeter-5.0/bin/mod-rtac-extend/:/mnt/jmeter/ \
>      -e "loki_host=http://ec2-54-165-58-65.compute-1.amazonaws.com" \
>      -e galloper_url=http://ec2-54-165-58-65.compute-1.amazonaws.com \
>      -e bucket=tests \
>      -e additional_files='{"tests/InfluxBackendListenerClient-1.1.jar": "/jmeter/apache-jmeter-5.0/lib/ext/InfluxBackendListenerClient.jar"}' \
>      getcarrier/perfmeter:latest \
>      -n -t /mnt/jmeter/mod_rtacTestPlan_cap4_updated2.jmx -JDURATION=1200 -Jtest_name=mod_rtacTestPlan -Jtest.type=baseline -Jenv.type=mod_rtac -JVUSERS=1 -JRAMP_UP=1 -Jinflux.host=ec2-54-165-58-65.compute-1.amazonaws.com -JLOOP_COUNT=100 -JP_PROTOCOL=https -JP_HOST=edge-cap4-us-east-1.int.aws.folio.org -JTPUT_PERIOD=12
level=warn ts=2020-03-03T21:06:31.6239799Z caller=filetargetmanager.go:98 msg="WARNING!!! entry_parser config is deprecated, please change to pipeline_stages"
level=info ts=2020-03-03T21:06:31.6243594Z caller=server.go:121 http=[::]:9080 grpc=[::]:44447 msg="server listening on addresses"
level=info ts=2020-03-03T21:06:31.6249983Z caller=main.go:66 msg="Starting Promtail" version="(version=master-dafb9d8, branch=master, revision=dafb9d84)"
telegraf process is not running [ FAILED ]
Starting the process telegraf [ OK ]
telegraf process was started [ OK ]
Using -Xmn1g -Xms1g -Xmx1g as JVM Args
START Running Jmeter on Tue Mar  3 21:06:34 UTC 2020
jmeter args=-n -t /mnt/jmeter/mod_rtacTestPlan_cap4_updated2.jmx -JDURATION=1200 -Jtest_name=mod_rtacTestPlan -Jtest.type=baseline -Jenv.type=mod_rtac -JVUSERS=1 -JRAMP_UP=1 -Jinflux.host=ec2-54-165-58-65.compute-1.amazonaws.com -JLOOP_COUNT=100 -JP_PROTOCOL=https -JP_HOST=edge-cap4-us-east-1.int.aws.folio.org -JTPUT_PERIOD=12 -Jinflux.port=8086 -Jinflux.db=jmeter -Jcomparison_db=comparison -Jlg.id=Lg_32487_713 -Jbuild.id=mod_rtacTestPlan_baseline_27716
OpenJDK 64-Bit Server VM warning: MaxNewSize (1048576k) is equal to or greater than the entire heap (1048576k).  A new max generation size of 1048064k will be used.
I> No access restrictor found, access to any MBean is allowed
Jolokia: Agent started with URL http://127.0.0.1:8080/jolokia/
Mar 03, 2020 9:06:36 PM java.util.prefs.FileSystemPreferences$1 run
INFO: Created user preferences directory.
level=info ts=2020-03-03T21:06:36.627379Z caller=filetargetmanager.go:257 msg="Adding target" key="{job=\"varlogs\"}"
Creating summariser <summary>
Created the tree successfully using /mnt/jmeter/mod_rtacTestPlan_cap4_updated2.jmx
Starting the test @ Tue Mar 03 21:06:37 UTC 2020 (1583269597353)
Waiting for possible Shutdown/StopTestNow/Heapdump message on port 4445
level=info ts=2020-03-03T21:06:46.595703Z caller=tailer.go:77 component=tailer msg="start tailing file" path=/tmp/mod_rtacTestPlan.log
ts=2020-03-03T21:06:46.5962633Z caller=log.go:124 component=tailer level=info msg="Seeked /tmp/mod_rtacTestPlan.log - &{Offset:0 Whence:0}"
summary +    130 in 00:00:20 =    6.4/s Avg:   144 Min:    95 Max:  1068 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary +    220 in 00:00:30 =    7.3/s Avg:   135 Min:    95 Max:  1085 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =    350 in 00:00:50 =    7.0/s Avg:   138 Min:    95 Max:  1085 Err:     0 (0.00%)
summary +    232 in 00:00:30 =    7.7/s Avg:   128 Min:   113 Max:   354 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =    582 in 00:01:20 =    7.2/s Avg:   134 Min:    95 Max:  1085 Err:     0 (0.00%)
summary +    199 in 00:00:30 =    6.6/s Avg:   149 Min:    74 Max:  1186 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =    781 in 00:01:50 =    7.1/s Avg:   138 Min:    74 Max:  1186 Err:     0 (0.00%)
summary +    219 in 00:00:30 =    7.3/s Avg:   136 Min:    76 Max:   922 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   1000 in 00:02:20 =    7.1/s Avg:   138 Min:    74 Max:  1186 Err:     0 (0.00%)
summary +    227 in 00:00:30 =    7.6/s Avg:   130 Min:   112 Max:   321 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   1227 in 00:02:50 =    7.2/s Avg:   136 Min:    74 Max:  1186 Err:     0 (0.00%)
summary +    228 in 00:00:30 =    7.6/s Avg:   130 Min:    75 Max:   959 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   1455 in 00:03:20 =    7.3/s Avg:   135 Min:    74 Max:  1186 Err:     0 (0.00%)
summary +    221 in 00:00:30 =    7.3/s Avg:   135 Min:    78 Max:  1012 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   1676 in 00:03:50 =    7.3/s Avg:   135 Min:    74 Max:  1186 Err:     0 (0.00%)
summary +    233 in 00:00:30 =    7.8/s Avg:   128 Min:   111 Max:   352 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   1909 in 00:04:20 =    7.3/s Avg:   134 Min:    74 Max:  1186 Err:     0 (0.00%)
summary +    223 in 00:00:30 =    7.4/s Avg:   133 Min:    73 Max:   963 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   2132 in 00:04:50 =    7.3/s Avg:   134 Min:    73 Max:  1186 Err:     0 (0.00%)
summary +    225 in 00:00:30 =    7.5/s Avg:   132 Min:    73 Max:   913 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   2357 in 00:05:20 =    7.4/s Avg:   134 Min:    73 Max:  1186 Err:     0 (0.00%)
summary +    222 in 00:00:30 =    7.4/s Avg:   134 Min:   111 Max:   791 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   2579 in 00:05:50 =    7.4/s Avg:   134 Min:    73 Max:  1186 Err:     0 (0.00%)
summary +    215 in 00:00:30 =    7.2/s Avg:   138 Min:   112 Max:  1667 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   2794 in 00:06:20 =    7.3/s Avg:   134 Min:    73 Max:  1667 Err:     0 (0.00%)
summary +    227 in 00:00:30 =    7.6/s Avg:   131 Min:    86 Max:   998 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   3021 in 00:06:50 =    7.4/s Avg:   134 Min:    73 Max:  1667 Err:     0 (0.00%)
summary +    225 in 00:00:30 =    7.5/s Avg:   133 Min:    74 Max:   970 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   3246 in 00:07:20 =    7.4/s Avg:   134 Min:    73 Max:  1667 Err:     0 (0.00%)
summary +    228 in 00:00:30 =    7.6/s Avg:   130 Min:   112 Max:   343 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   3474 in 00:07:50 =    7.4/s Avg:   134 Min:    73 Max:  1667 Err:     0 (0.00%)
summary +    225 in 00:00:30 =    7.5/s Avg:   132 Min:    77 Max:   958 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   3699 in 00:08:20 =    7.4/s Avg:   134 Min:    73 Max:  1667 Err:     0 (0.00%)
summary +    219 in 00:00:30 =    7.3/s Avg:   134 Min:    71 Max:   909 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   3918 in 00:08:50 =    7.4/s Avg:   134 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    239 in 00:00:30 =    8.0/s Avg:   125 Min:   111 Max:   260 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   4157 in 00:09:20 =    7.4/s Avg:   133 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    224 in 00:00:30 =    7.5/s Avg:   132 Min:    80 Max:   972 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   4381 in 00:09:50 =    7.4/s Avg:   133 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    224 in 00:00:30 =    7.5/s Avg:   133 Min:    79 Max:  1007 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   4605 in 00:10:20 =    7.4/s Avg:   133 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    229 in 00:00:31 =    7.5/s Avg:   132 Min:    78 Max:   995 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   4834 in 00:10:51 =    7.4/s Avg:   133 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    133 in 00:00:30 =    4.5/s Avg:   221 Min:   111 Max:  1519 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   4967 in 00:11:20 =    7.3/s Avg:   135 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    223 in 00:00:30 =    7.4/s Avg:   133 Min:    71 Max:   924 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   5190 in 00:11:50 =    7.3/s Avg:   135 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    232 in 00:00:30 =    7.7/s Avg:   128 Min:   111 Max:   303 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   5422 in 00:12:20 =    7.3/s Avg:   135 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    225 in 00:00:30 =    7.5/s Avg:   132 Min:    81 Max:   856 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   5647 in 00:12:50 =    7.3/s Avg:   135 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    231 in 00:00:30 =    7.7/s Avg:   129 Min:    72 Max:   926 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   5878 in 00:13:20 =    7.3/s Avg:   135 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    228 in 00:00:30 =    7.6/s Avg:   130 Min:   113 Max:   277 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   6106 in 00:13:50 =    7.4/s Avg:   134 Min:    71 Max:  1667 Err:     0 (0.00%)
summary +    230 in 00:00:30 =    7.7/s Avg:   129 Min:    70 Max:   937 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   6336 in 00:14:20 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +    222 in 00:00:30 =    7.4/s Avg:   134 Min:    74 Max:  1010 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   6558 in 00:14:50 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +    226 in 00:00:30 =    7.5/s Avg:   132 Min:    78 Max:   955 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   6784 in 00:15:20 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +    230 in 00:00:30 =    7.7/s Avg:   129 Min:   112 Max:   433 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   7014 in 00:15:50 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +    198 in 00:00:30 =    6.6/s Avg:   151 Min:    78 Max:   929 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   7212 in 00:16:20 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +    229 in 00:00:30 =    7.6/s Avg:   130 Min:    81 Max:   970 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   7441 in 00:16:50 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +    237 in 00:00:30 =    7.9/s Avg:   126 Min:   112 Max:   270 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   7678 in 00:17:20 =    7.4/s Avg:   134 Min:    70 Max:  1667 Err:     0 (0.00%)
summary +     54 in 00:00:30 =    1.8/s Avg:   561 Min:   113 Max:  2802 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   7732 in 00:17:51 =    7.2/s Avg:   137 Min:    70 Max:  2802 Err:     0 (0.00%)
summary +    162 in 00:00:30 =    5.5/s Avg:   182 Min:   111 Max:  1189 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   7894 in 00:18:20 =    7.2/s Avg:   138 Min:    70 Max:  2802 Err:     0 (0.00%)
summary +    209 in 00:00:30 =    6.9/s Avg:   143 Min:    81 Max:  1017 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   8103 in 00:18:50 =    7.2/s Avg:   138 Min:    70 Max:  2802 Err:     0 (0.00%)
summary +     38 in 00:00:30 =    1.3/s Avg:   795 Min:   294 Max:  1556 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   8141 in 00:19:21 =    7.0/s Avg:   141 Min:    70 Max:  2802 Err:     0 (0.00%)
summary +     35 in 00:00:30 =    1.2/s Avg:   850 Min:   423 Max:  1141 Err:     0 (0.00%) Active: 1 Started: 1 Finished: 0
summary =   8176 in 00:19:50 =    6.9/s Avg:   144 Min:    70 Max:  2802 Err:     0 (0.00%)
summary +     15 in 00:00:12 =    1.3/s Avg:   789 Min:   518 Max:  1063 Err:     0 (0.00%) Active: 0 Started: 1 Finished: 1
summary =   8191 in 00:20:02 =    6.8/s Avg:   145 Min:    70 Max:  2802 Err:     0 (0.00%)
Tidying up ...    @ Tue Mar 03 21:26:42 UTC 2020 (1583270802103)
... end of run
----------------------------------
Tests are done
Baseline not found
END Running Jmeter on Tue Mar  3 21:26:43 UTC 2020
lpmc-cgodfrey:mod-rtac-extend cgodfrey$ 


```

Observations can be made by viewing grafana dashboard:

http://ec2-54-165-58-65.compute-1.amazonaws.com/grafana/d/q69rYQlik/jmeter-performance?orgId=1&var-percentile=95&var-test_type=baseline&var-test=mod_rtacTestPlan&var-env=mod_rtac&var-grouping=1s&var-low_limit=250&var-high_limit=700&var-db_name=jmeter&var-sampler_type=All&from=now-1h&to=now


## Current limitations/Issues

- Jmx file name cannot contain - in the name
- timing is only provided in grafana output for modules that are explcitly called from JMeter tests. For example -- when calling rtac/${instance} from a Jmeter tests timing data is not generated for underlying api calls that are made from mod-rtac 





