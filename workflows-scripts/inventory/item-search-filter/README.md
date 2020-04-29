## Workflow steps:

##### Workflow for inventory_itemSearch.jmx
1. Open Inventory App
2. Select Item tab in top left
3. Select Item status drop down and check "Available" 
4. Uncheck "Available"
5. In same drop down check "In transit"
6. Uncheck "In transit"
7. Select "Suppress from discovery" drop down and check "Yes"
8. Goto items tab and Select Nature of content = Newspaper
9. Select Effective location (item) dropdown and add following locations
    UC/HP/AANet/Intrnet or UC/HP/ASR/ACASA or UC/HP/ASR/ARCHASR or UC/HP/ASR/ASRHP or UC/HP/ASR/Atk or bUC/HP/ASR/GameASR or UC/HP/ASR/HarpASR or UC/HP/ASR/JRLASR or UC/HP/ASR/LawASR
   These locations are from the PTF perf testing environment (database)

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-19.1.2
- mod-inventory-14.1.2
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.35.2
##### Frontend:
- folio_inventory-2.0.2

- FOLIO release: FameFlower