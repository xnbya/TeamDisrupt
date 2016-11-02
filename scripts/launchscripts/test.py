#!/usr/bin/python

#script to start instance based on config file

import boto3, configparser, time, os

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"
#f=open("dbserver.sh")
#script=f.read()


#launch instances
#get IPs
print('setting up database server')
#db password
dbpass = 'hunter3'
print('password', dbpass)

def runcmd(servip, command):
    os.system('ssh -oStrictHostKeyChecking=no -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + servip + " " + command )

runcmd("52.58.31.198", '"`cat gitsetup.sh`"')
print("GIT setup")
runcmd("52.58.31.198", '"bash ~/TeamDisrupt/scripts/launchscripts/db-server.sh ' + dbpass + '"')

print("DB server setup, starting appserver")

runcmd("52.57.225.182", '"`cat gitsetup.sh`"')
runcmd("52.57.225.182", '"bash ~/TeamDisrupt/scripts/launchscripts/staging-server.sh ' + dbpass + ' ' + "52.58.31.198" + '"')






