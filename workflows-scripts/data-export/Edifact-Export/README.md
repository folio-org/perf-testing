## Begin steps:
1. Provide parameters into CSV username,password,tenantId,ftpPassword
2. Provide parameter "okapiHostname"
3. If needed edit parameters in request bodies like ftp server info, time for scheduler
4. Additional (disabled thread group) containing disabling/enablind mod-data-export-spring module before test if needed


##### Workflow steps for EdifactScheduler.jmx
1. Enable Edifact scheduler +5 minutes from current time for list of organizations:
    - 2e6d8468-0620-475b-a092-045e659a0aaa
    - e02e4507-3c3a-40e5-b2f6-dbb9a15ac950
    - ede1513a-ea9b-46e5-8f2c-7d93836f9742
    - 1a36d83e-526f-48ad-9956-4e341a40fbbb
    - 6d363fea-c0e3-4c32-8074-4124b0a2307e
    - 382831f9-c680-4b7e-a3ab-daa3022fa4cb
    - da29ee41-727a-4372-9472-7818c948f8c7
    - 02c0820c-108c-41c4-ab9c-d289877e8dfa
    - 2d6f2d47-9664-4794-8cd5-4e168bd57384
    - a58a5dcc-7e60-492f-b795-7a791c0970fe
2. 10 minutes pause
3. Disable Edifact scheduler for listed organizations


## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-orders-storage:13.5.0
- mod-orders:12.6.6
- mod-organizations:1.7.0
- mod-organizations-storage:4.5.1
- mod-data-export-worker:3.0.12
- mod-data-export-spring:2.0.2


- FOLIO release: Orchid