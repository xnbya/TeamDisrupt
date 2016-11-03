#!/bin/bash 

#######################################################################
#
# Description of this script:
# 
# This script connects to a Postgres database using the credentials specified
# in parameters and creates a dump of it, saving the result to the specified
# folder using the `YYYY-MM-DD_HH-mm-SS.sql` format.
#
# This script uses `pg_dump` command, so if it is not found the script will
# throw an error. Before running `pg_dump`, the script will create a `~/.pgpass`
# file with login credentials, deleting it after `pg_dump` will finish its 
# execution. If `~/.pgpass` already exists, the script will throw an error.
#
# If the `[days]` parameter is specified, script will proceed to scan
# the `<dir>` directory and remove all files older than `[days]` days.
#
# Run this script without any parameters to see usage instructions.
#
# Example:
# 
# /db-backup.sh 54.93.198.216 5432 simpleref_test postgres hunter2 ./dumps 1
# 
# Running the command above will make a dump of the `simpleref_test` database
# in the `./dumps` directory (given it exists) and delete all other dumps in
# this directory that are older than 1 day.
#
#######################################################################

programname=$0

function usage {
    echo "usage: $programname <host> <port> <db> <user> <pass> <dir> [days]"
    echo "      <host>         host on which Postgres server is running"
    echo "      <port>         port used by the Postgres server"
    echo "      <db>           name of the database"
    echo "      <user>         name of the Postgres user"
    echo "      <pass>         password of said user"
    echo "      <dir>          absolute path to the directory where dumps should be stored"
    echo "      [days]         delete all files in <dir> that are older than [days] days"
}

# Print usage instructions if no arguments are supplied
if [ "$#" -eq 0 ]
then
    usage
    exit 0
fi

# Check that the amount of arguments is correct
if [ "$#" -lt 6 ] || [ "$#" -gt 7 ]
then
    echo "Invalid amount of arguments!"
    exit 1
fi

# Check if specified directory exists
if [ ! -d "$6" ]
then
    echo "'$6' is not a directory!"
    exit 1
fi

# Set variables from parameters
host="$1"
port="$2"
db="$3"
user="$4"
pass="$5"
dir="$6"

# Add a trailing slash to `$dir` if it's not there
dirlength=$((${#dir}-1))
dirlastchar=${dir:$dirlength:1} 
if [ ! $dirlastchar == "/" ]
then
    dir="$dir/"
fi

# Check if [days] is set and if it's an integer
# Note: This check ALLOWS negative dates
if [ "$#" -eq 7 ]
then
    regex='^-?[0-9]+$'
    if [[ ! $7 =~ $regex ]]
    then
        echo "'$7' is not an integer!"
        exit 1
    fi
    days=$7
fi

# Check that `pg_dump` command exists, otherwise throw an error
dumpcommand="pg_dump"
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

# Fetch the dump from remote database
echo "Retreiving the dump of the database..."
dump=$(eval "$dumpcommand -U $user -h $host $db")
echo "Dump retreived successfully!"

# Delete `~/.pgpass` since it's not needed anymore
echo "Deleting '$pgpasspath'..."
rm $pgpasspath

# Save the dump
dumpfile="$(date +"%Y-%m-%d_%H-%M-%S").sql"
echo "Saving dump with the name '$dumpfile' into '$dir'..."
echo "$dump" > $dir$dumpfile
echo "Done!"

# Delete files older than [days] if [days] is set
if [ ! -z ${days+x} ]
then
    echo "'[days]' is set, deleting file(s) older than $days days from '$dir'..."
    counter=0
    now=$(date +%s)
    dayseconds="$(expr 3600 "*" 24)"
    for filename in $dir*.sql
    do
        if [ ! -e "$filename" ]
        then
            continue
        fi
        lastmodified=$(eval "date +%s -r $filename")
        secondselapsed="$(expr $now - $lastmodified)"
        dayselapsed="$(expr $secondselapsed "/" $dayseconds)"
        if [ $dayselapsed -gt $days ]
        then
            echo "Dump has expired, deleting!"
            counter=$((counter+1))
            rm "$filename"
        fi
    done
    echo "Deleted $counter file(s)."
else
    echo "'[days]' is not set, NOT deleting anything."
fi

exit 0
