#!/usr/bin/python3

# script to connect to database as setup in launch.py and restore
# db dump passed as parameter (from loal machine)

import boto3, configparser, time, os, pickle, sys

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"

#check to see if instances exist
if (not config.has_section('instances')):
        print("Instances do not exist in config")
        sys.exit()

#copy db dump to server
os.system('scp -i ' + config.get(myconfig, "key-location") + ' ' + sys.argv[1] + ' ' + ubuntu@' + config.get('instances', 'dbip:~/backup.sql')) 

os.system('ssh -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + config.get('instances', 'dbip')) 
