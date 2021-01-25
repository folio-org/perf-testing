/* To use this script, enter the command:
$ psql -f db-restore.sql -a --echo-all
Also supply the values for -h, -d, -U if applicable

This script will remove all the notes from the table. It is expected that the notes will be repopulated by another script.
*/

TRUNCATE TABLE fs09000000_mod_notes.note_data;
