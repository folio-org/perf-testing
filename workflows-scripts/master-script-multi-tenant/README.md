## Workflow steps:
##### Workflow for master-script-poc-multi-tenant.jmx preparation
1. Open multi-tenant-master-script\jmeter-supported-data\tenants_credentials.csv and add tenant credentials by template. One row for one tenant.
2. Add all test data to multi-tenant-master-script\jmeter-supported-data\[tenantId] folder.
3. Edit multi-tenant-master-script.jmx to disable/enable needed Thread Groups (flows) in jMeter tool
4. In User Defined Variables check total_tenants parameter (should equals the total number of tenants).
5. Archive all folders and zip file with all updated data and upload to carrier-io.