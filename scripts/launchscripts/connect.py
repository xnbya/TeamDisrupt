#!/usr/bin/python3

#script to ssh into instance
#pass db or app as arg

import boto3, configparser, time, os, pickle, sys

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"

#check to see if instances exist
if (not config.has_section('instances')):
        print("Instances do not exist in config")
        sys.exit()

print('Connecting to ' +  config.get('instances', sys.argv[1] + 'ip' ))

os.system('ssh -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + config.get('instances', sys.argv[1] + 'ip')) 

