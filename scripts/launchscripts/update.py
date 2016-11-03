#!/usr/bin/python3

# this script updates app server to newest github version
# pass branch as parameter

import boto3, configparser, time, os, pickle, sys

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"

#check to see if instances exist
if (not config.has_section('instances')):
        print("Instances do not exist in config")
        sys.exit()

#check args
if len(sys.argv) != 2:
    print("update script \n pass branch as parameter \n eg ./update.py development")
    sys.exit()



os.system('ssh -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + config.get('instances', 'appip') + ' "bash -s" < ../hooks/deployment.sh "' + sys.argv[1] + '"') 

print('Updated ' +  config.get('instances', 'appip' ) + ' to ' + sys.argv[1])
