#!/bin/sh -e

if [ $# -ne 2 ]; then
   echo "Usage: $0 <db config> <TENANT>";
   echo "       $0 psql.conf diku";

   exit 1;
fi

DBCONF="${1}"
export TENANT="${2}"

export PGDATABASE=`cat "$DBCONF" | jq -r '.database'`
export PGUSER=`    cat "$DBCONF" | jq -r '.username'`
export PGPASSWORD=`cat "$DBCONF" | jq -r '.password'`
export PGHOST=`    cat "$DBCONF" | jq -r '.host'`
export PGPORT=`    cat "$DBCONF" | jq -r '.port'`

SQL=`echo "$0" | sed 's/.sh$/.sql/'`

cat "$SQL" | sed "s/fs09000000/$TENANT/" | psql

