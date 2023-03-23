## Workflow steps:
##### Workflow for users_patronRecordOperations.jmx

Create User:

1. Go to user app
2. Click on "Actions" button and select New
3. Fill out the form for the following required fields: LName, patron group, status, user email, preferred contact.
4. Hit Save and Close

View User And User's loan history:

1. In the Keyword field, search for the user by last name and/or first name
2. If only one name in the database, then the detail of the user will appear on the third pane.
3. Scroll down and expand on the Loans accordion panel.
4. Click on "X open loans" or "x closed loans" to view loan history

Edit User:

1. In the Keyword field, search for the user by last name and/or first name
2. If only one name in the database, then the detail of the user will appear on the third pane.
3. Click on the third pane's Actions button and select Edit
4. Update one or several fields

Delete User:

1. In the Keyword field, search for the user by last name and/or first name
2. If only one name in the database, then the detail of the user will appear on the third pane.
3. Click on the third pane's Actions button and select Check for open transactions/delete user
4. In the pop up window that confirms deletion, click on Yes.

## Modules required to be enabled as a pre-requisite to run JMeter script:
##### Backend:
- mod-users-19.0.0
- mod-users-bl-7.4.0
- mod-authtoken-2.12.0
- mod-permissions-6.2.0
- okapi-4.14.7
##### Frontend:
- folio_users-8.2.4
- FOLIO release: Nolana

## JMeter-supported-data
### Runtime Data
The following data files are needed to support the Jmeter script during its execution.
- users.scv: a list of uuids and names of actual users that will be used to execute the script.
- credentials.csv: a file to specify credentials for the tenant being tested.

### Parameters
#### Environment and Configuration
- Protocol
- Host
- VUSERS		count of concurrent users.
- RAMP_UP		the amount of time it will take the script to add all test users (threads) to a test execution.
- DURATION		timespan between start and end of the script
- LOOPS			not used with the script but predefined for some purposes in the future and should not be used in Delete scenario.
#### Probabilities of scenarios
- Prob_OpenClose		OpenClose scenario for View
- Prob_CreateUser		Create
- Prob_ViewUserLoans	View
- Prob_EditUser			Edit
- Prob_DeleteUser		Delete

## Setup data before running JMeter script:
- Take a DB Dump as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764

- Create zip archive with users_patronRecordOperations.jmx and all content located in jmeter-supported-data folder.
- Upload the zip into.

## Run JMeter script
Example of command:
```shell
jmeter -n -t users_patronRecordOperations.jmx -J VUSERS=2 -l report.csv -e -o HTML
```
## Setup data after running JMeter script:
- Restore a DB Dump as described here:
  https://wiki.folio.org/pages/viewpage.action?pageId=118262764