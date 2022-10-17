## Using the scripts in this directory
- db-restore.sql deletes all the notes in the database. Run it before and after a test.
- notes-data-load.sh seeds the data with 500K notes to give it an initial condition.  These 500K notes are from notes.json.tar.gz, also in the same directory
These two scripts are to be run manually on the box that could connect to the database. 

To run the data load script:
1. Go to an AWS EC2 jump box that's in the same environment as that DB.
2. Pull down the content in this directory that contains the seed data (notes.json.tar.gz). Unzip it.
3. Navigate to the directory that contains the seed data files
4. Fill in psql.conf with the following fields:
`{
     "database":"",
     "username":"",
     "password":"",
     "host":"",
     "port":""
 }`
5. Execute the script as follows: ./notes-data-load.sh db.conf \<tenant-ID\>

To run the database restore script:
1. Go to an AWS EC2 jump box that's in the same environment as that DB.
2. Replace the variable {tenantId} in the script with an actual tenantId.
3. Execute > psql -f db-restore.sql -a --echo-all -h \<database-host-name\> -U \<db-username\> -d \<db-name\>
4. Enter password when prompted



