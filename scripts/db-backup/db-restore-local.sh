#!/bin/bash 

#######################################################################
#
# Description of this script:
#
# run this script as postgres user on db server!!!!
# 
# This script restores the specified database using the SQL file with a
# database dump specified in parameters. This script uses `psql` command
# to execute SQL queries on the remote server, so if it is not available
# the script will throw an error.
#
# NOTE: We cannot drop the database because there might be other clients
# connected to the database at the same time, so instead this script drops
# the `public` schema and creates a new, empty one with the same name.
# Then, the script proceeds to execute all SQL queries in the dump file
# one by one.
#
# Example:
#
# ./db-restore.sh simpleref_test dumps/2016-11-02_12-48-08.sql
#
# This command will erase the contents of the `simpleref_test` database and
# populate it with the content that saved in the dump.
#
#######################################################################

programname=$0

function usage {
    echo "usage: $programname <db> <dumpfile>"
    echo "      <db>           name of the database"
    echo "      <dumpfile>     SQL dump that will be used to restore the database"
}

# Print usage instructions if no arguments are supplied
if [ "$#" -eq 0 ]
then
    usage
    exit 0
fi

# Check that the amount of arguments is correct
if [ ! "$#" -eq 2 ] 
then
    echo "Invalid amount of arguments!"
    exit 1
fi

# Check that the specified dump file exists and is readable
if [ ! -r "$2" ]
then
    echo "'$2' does not exist or is not readable!"
    exit 1
fi

# Set variables from parameters
db="$1"
dumpfile="$2"

# Check that `pg_restore` command exists, otherwise throw an error
dumpcommand="psql"
if ! command -v "$dumpcommand" > /dev/null
then
    echo "'$dumpcommand' command was not found!"
    echo "Run 'sudo apt-get install postgresql-client' to install it."
    exit 1
else
    echo "'$dumpcommand' command is available, moving on..."
fi

# Restore the database from the dump file 
echo "Restoring '$db' database using '$dumpfile' dump..."
eval "echo \"DROP SCHEMA public CASCADE;\" | sudo -u postgres $dumpcommand $db"
eval "echo \"CREATE SCHEMA public;\" | sudo -u postgres $dumpcommand $db"
eval "echo \"GRANT ALL ON SCHEMA public TO postgres;\" | sudo -u postgres $dumpcommand $db"
eval "echo \"GRANT ALL ON SCHEMA public TO public;\" | sudo -u postgres $dumpcommand $db"
eval "sudo -u postgres $dumpcommand $db < $dumpfile"
echo "Database restored successfully!"

exit 0
