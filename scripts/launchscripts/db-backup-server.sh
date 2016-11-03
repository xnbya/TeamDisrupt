#!/bin/bash
##################
# script to setup database backup server
# takes password of db server and ip address as arguments
# defaults to backing up once a day
# deletes backups older than 7 days
# saves backups to /home/ubuntu/backups
######################

dbpass=$1
dbhost=$2



