#!/bin/bash
# Script to check for the number of active connections to the postgress database
pg_connections=`psql -xtA -U postgres -c "SELECT sum(numbackends) FROM pg_stat_database;"  | sed 's/[^0-9]*//g'`
echo "0:$pg_connections:OK"