#!/usr/bin/env bash

######################################################################
#
# Description of this script:
#
# This script shuts down the tmux session running Rails, backs up the
# existing `database.yml` file, resets the current repository to the
# most recent state of the branch specified in parameters, restores
# backed up `database.yml` and rums a tmux session running Rails.
#
######################################################################

programname=$0

function usage {
    echo "usage: $programname <branch>"
    echo "      <branch>         Git branch from which the most recent changes will be pulled"
}

# Print usage instructions if no arguments are supplied
if [ "$#" -eq 0 ]
then
    usage
    exit 0
fi

# Check that the amount of arguments is correct
if [ ! "$#" -eq 1 ]
then
    echo "You must specify the branch!"
    exit 1
fi

branch="$1"

# Switch to `webapp` folder
dir=~/dev/TeamDisrupt/webapp/
echo "Switching to '$dir'..."
cd $dir

# Kill tmux session called $sessionname
sessionname="my-session"
echo "Killing '$sessionname' tmux session..."
eval "tmux kill-session -t $sessionname"

# Store the contents of $dbconfig
dbconfig="config/database.yml"
echo "Backing up '$dbconfig'..."
dbtmp=$(< $dbconfig)

# Reset the repo to the most recent version online
echo "Fetching most recent change from branch '$branch'..."
eval "git fetch -a"
eval "git reset --hard origin/$branch"

# Restore $dbconfig
echo "$dbtmp" > $dbconfig

# Migrate the DB
echo "Migrating the database..."
rake db:migrate

# Restart rails
echo "Starting up the Rails server..."
eval "tmux -d -s $sessionname \"rails s -b 0.0.0.0\""
