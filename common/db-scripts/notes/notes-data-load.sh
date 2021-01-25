#!/bin/bash -e

if [[ $# -lt 2 ]]; then
   echo "Usage: $0 <db config> <TENANT> [--clear-loan-audit]";
   echo "       $0 psql.conf diku";

   exit 1;
fi

DBCONF=${1}
export TENANT=${2}

export PGDATABASE=`cat $DBCONF | jq '.database' | cut -d\" -f2`
export PGUSER=`cat $DBCONF | jq '.username' | cut -d\" -f2`
export PGPASSWORD=`cat $DBCONF | jq '.password' | cut -d\" -f2`
export PGHOST=`cat $DBCONF | jq '.host' | cut -d\" -f2`
export PGPORT=`cat $DBCONF | jq '.port' | cut -d\" -f2`

NOTES="notes.tsv"

echo "================================================="
echo "PGUSER: $PGUSER"
echo "PGPASSWORD: $PGPASSWORD"
echo "PGDATABASE: $PGDATABASE"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
echo "TENANT: $TENANT"
echo ""
echo "NOTES: $NOTES"
echo "=================================================="

# ==================================================
#  re-populate the database
# ==================================================
export WORK_DIR=/tmp/$(uuidgen)
mkdir ${WORK_DIR}
echo Working directory is ${WORK_DIR}

[ -e ${WORK_DIR}/delete.sql ] && rm ${WORK_DIR}/delete.sql

test "null" != "${NOTES}" && echo "ALTER TABLE ${TENANT}_mod_notes.note_data DROP CONSTRAINT IF EXISTS note_data_pkey;" >> ${WORK_DIR}/delete.sql
test "null" != "${NOTES}" && echo "DROP INDEX IF EXISTS ${TENANT}_note_data_title_idx_like;">> ${WORK_DIR}/delete.sql

echo "commit;" >> ${WORK_DIR}/delete.sql
cat ${WORK_DIR}/delete.sql
${RUN_PSQL} < ${WORK_DIR}/delete.sql


test "null" != "${NOTES}" && psql -a -c "\copy ${TENANT}_mod_notes.note_data(id, jsonb) FROM '${NOTES}' DELIMITER E'\t'"


#if file exists
[ -e ${WORK_DIR}/create_index.sql ] && rm ${WORK_DIR}/create_index.sql

test "null" != "${NOTES}" && echo "CREATE INDEX note_data_title_idx_like ON ${TENANT}_mod_notes.note_data USING btree (lower(${TENANT}_mod_notes.f_unaccent(jsonb ->> 'title'::text)) COLLATE pg_catalog."default" text_pattern_ops ASC NULLS LAST);" >> ${WORK_DIR}/create_index.sql
test "null" != "${NOTES}" && echo "CREATE UNIQUE INDEX note_data_pkey ON ${TENANT}_mod_notes.note_data USING btree (id);" >> ${WORK_DIR}/create_index.sql

if [ -e ${WORK_DIR}/create_index.sql ]; then
    echo "commit;" >> ${WORK_DIR}/create_index.sql
    cat ${WORK_DIR}/create_index.sql
    ${RUN_PSQL} < ${WORK_DIR}/create_index.sql
fi

# optimize postgres queries
test "null" != "${NOTES}" && psql -a -c "vacuum verbose analyze ${TENANT}_mod_notes.note_data;"

# remove working directory
rm -fr ${WORK_DIR}
 

exit 0;