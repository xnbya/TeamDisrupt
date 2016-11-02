#!/bin/bash 

#######################################################################
#
# Description of this script:
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
# ./db-restore.sh 54.93.198.216 5432 simpleref_test postgres hunter2 dumps/2016-11-02_12-48-08.sql
#
# This command will erase the contents of the `simpleref_test` database and
# populate it with the content that saved in the dump.
#
#######################################################################

programname=$0

function usage {
    echo "usage: $programname <host> <port> <db> <user> <pass> <dumpfile>"
    echo "      <host>         host on which Postgres server is running"
    echo "      <port>         port used by the Postgres server"
    echo "      <db>           name of the database"
    echo "      <user>         name of the Postgres user"
    echo "      <pass>         password of said user"
    echo "      <dumpfile>     SQL dump that will be used to restore the database"
}

# Print usage instructions if no arguments are supplied
if [ "$#" -eq 0 ]
then
    usage
    exit 0
fi

# Check that the amount of arguments is correct
if [ ! "$#" -eq 6 ] 
then
    echo "Invalid amount of arguments!"
    exit 1
fi

# Check that the specified dump file exists and is readable
if [ ! -r "$6" ]
then
    echo "'$6' does not exist or is not readable!"
    exit 1
fi

# Set variables from parameters
host="$1"
port="$2"
db="$3"
user="$4"
pass="$5"
dumpfile="$6"

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

# Create `~/.pgpass` file if it doesn't exist, throw an error otherwise
pgpasspath=~/.pgpass
if [ -e $pgpasspath ]
then
    echo "'$pgpasspath' exists, delete it before running the script!"
    exit 1
else
    echo "Creating '$pgpasspath'..."
    echo "$host:$port:$db:$user:$pass" > $pgpasspath 
    echo "Changing permissions on '$pgpasspath' to 600..."
    chmod 600 $pgpasspath
fi

# Restore the remote database from the dump file 
echo "Restoring '$db' database using '$dumpfile' dump..."
eval "echo \"DROP SCHEMA public CASCADE;\" | $dumpcommand -U $user -h $host $db"
eval "echo \"CREATE SCHEMA public;\" | $dumpcommand -U $user -h $host $db"
eval "echo \"GRANT ALL ON SCHEMA public TO postgres;\" | $dumpcommand -U $user -h $host $db"
eval "echo \"GRANT ALL ON SCHEMA public TO public;\" | $dumpcommand -U $user -h $host $db"
eval "$dumpcommand -U $user -h $host $db < $dumpfile"
echo "Database restored successfully!"

# Delete `~/.pgpass` since it's not needed anymore
echo "Deleting '$pgpasspath'..."
rm $pgpasspath

exit 0
