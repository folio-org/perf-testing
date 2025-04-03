## Workflow steps:

##### bib_authorityCreateEdit.jmx
1. Go to MARC-Authority App
2. Go Actions, press New
3. Copy fields from any existing authority record to paste it
4. Hit Save and Close

1. Go to MARC-Authority App
2. Enter a keyword to search with (hrid or natural Id). It should be created during previous scenario
3. Choose found record
4. Go Actions, press edit
5. Edit a field, e.g. 110 (or some other field), simply by appending a character or two at the end of the string. 
6. Hit Save and Close

1. Go to Inventory App
2. Go Actions, press New
3. Copy fields from any existing MARC BIB record and fill in
4. Hit Save and Close

## Modules required(minimum required versions) to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-inventory-storage-28.0.9
- mod-inventory-21.0.12
- mod-login-keycloak-2.0.2
- mod-users-19.4.5
- mod-roles-keycloak-2.0.15
- mod-users-keycloak-2.0.5

##### Frontend:
- folio_inventory-9.2.8

- FOLIO release: Ramsons
###### Csv data config files
They are used for test parameterization, for creating different data sets for different users in the same test script.
- credentials.csv (contains username,password,tenant, they are needed for login)
- keywords.csv not used during authority edit actions cuz it uses newly created records in previous scenrio
