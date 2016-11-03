#!/usr/bin/python3

# script to connect to database as setup in launch.py and restore
# db dump passed as parameter 1 (from loal machine)
# db name passed as param 2

import boto3, configparser, time, os, pickle, sys

#check params
if(len(sys.argv) != 3):
    print("Invalid number of arguments \n Please supply dump as 1st argument and db name as 2nd argument")
    print("eg ./restore-db.py backup.sql simpleref-development")
    sys.exit()

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"

#check to see if instances exist
if (not config.has_section('instances')):
        print("Instances do not exist in config")
        sys.exit()

#copy db dump to server
os.system('scp -i ' + config.get(myconfig, "key-location") + ' ' + sys.argv[1] + ' ' + 'ubuntu@' + config.get('instances', 'dbip') + ':~/backup.sql') 

#run restorescript
os.system('ssh -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + config.get('instances', 'dbip')  + ' "~/TeamDisrupt/scripts/db-backup/db-restore-local.sh simpleref-development ' + sys.argv[2] + '"') 
