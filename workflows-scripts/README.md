## Steps to run JMeter script:

##### Using GUI:
1. Open .jmx file in JMeter IDE
2. Change credentials in jmeter-supported-data\credentials.csv 
[username],[password],[tenantId]
3. Change hostname in User Defined Variables
4. Click to the play button

##### NON GUI mode
run the command:

jmeter -n -t [path_to_project]/perf-testing/workflows-scripts/[workflow-name]/[file_name].jmx -l [path_to_project]/perf-testing/workflows-scripts/[workflow-name]/log.jtl

where [path_to_project] - a path to perf-testing project
      [workflow-name] - a name of workflow-name
      [file_name] - a jmx file name 