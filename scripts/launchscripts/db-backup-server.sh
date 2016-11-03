#!/bin/bash
##################
# script to setup database backup server
# takes password of db server and ip address as arguments
# defaults to backing up once a day
# deletes backups older than 20 days
# saves backups to /home/ubuntu/backups
######################

dbpass=$1
dbhost=$2
dbname=$3

sudo apt-get install -y postgresql-client

mkdir ~/backups/
echo "0 * * * * ~/TeamDisrupt/scripts/db-backup/db-backup.sh $dbhost 5432 $dbname pgadmin $dbpass ~/backups/ 20" | crontab -






