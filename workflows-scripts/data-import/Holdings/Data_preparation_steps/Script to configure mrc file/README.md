## Introduction
This is a script which replace instance HRIDs in .mrc file for data import of holdings with actual for the specific environment.

## Usage
- Python should be installed on your local machine.
- Prepare the txt file with instance HRIDs for the tenant to run data import using the query. At least one instance HRID for 1000 holdings.
- Instance HRIDs should be the same tenant where jsonb->>'source' = 'MARC' and jsonb->>'discoverySuppress' = 'false'