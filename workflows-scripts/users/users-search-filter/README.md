## Workflow steps:
##### Workflow for users_search.jmx
1. Open Users App
2. Select Status dropdown
3. Check "active" status
4. Keep scrolling until you see Load More button (behind the scene, a query will be made to backend module by increasing offset)
5. Do point 4 couple of times (page renders very slow)

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users-16.1.0
- mod-users-bl-5.3.0
- mod-authtoken-2.4.0
- mod-permissions-5.9.0
- okapi-2.35.2
##### Frontend:
- folio_users-3.0.3

- FOLIO release: FameFlower