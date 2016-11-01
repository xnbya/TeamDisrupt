#!/bin/bash 

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
if [ "$#" -eq 7 ]
then
    regex='^[0-9]+$'
    if [ ! $7 =~ $regex ]
    then
        echo "'$7' is not an integer!"
        exit 1
    fi
    days=$7
fi

# Check that `pg_dump` command exists, otherwise install pg client
dumpcommand="pg_dump"
if ! type "$dumpcommand" > /dev/null
then
    echo "'$dumpcommand' was not found, installed Postgres client tools..."
    sudo apt-get install pgclient
else
    echo "'$dumpcommand' command is available, moving on..."
fi

#eval "pg_dump -U postgres -h 54.93.192.216 simpleref_db"
#eval "pg_dump -h $host -U postgres $db"

# Delete files older that [days]
for filename in $dir*
do
    echo "$filename"
done






exit 0
