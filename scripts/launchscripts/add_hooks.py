#!/usr/bin/python3

# this script updates app server
# adds ssh key and config for auto update when repo changes

import boto3, configparser, time, os, pickle, sys

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"

#check to see if instances exist
if (not config.has_section('instances')):
        print("Instances do not exist in config")
        sys.exit()


os.system('ssh -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + config.get('instances', 'appip') + ' "echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDD9Pm7PM/DVxgyf2sM3zG907qu2TUdTKyhWJKYv9tVTxIX/ljR/SNTjoyrZcpZFuVY1Wy1ss5pc5U5cQEmTT7Dvrh/Dsz2TZLw6j2ga7eccb6rXWSaFxOGCXHz0kHt0bVMxDHrQh/cMOebxWd94NgYhOLqQMpLgbQMjcd1iOa6PjJ5+6sueF+WeipLG8L9aT/wNL2guyf6aoWrNYq9wo0jdktu0iP7H7apvJnX191dNL5cxGrKkR9on6Fca2WxHkxNTued2rckdEmXsFV2TgHw88uOviF6+GmFbiwV8Zne/gqXV7zrKV0js+Q20QjKrQGWAyTeLqdRU4zL1FQqQhUF euql1n@kawaii-desu" >> ~/.ssh/authorized_keys"') 
os.system('curl https://hosting.kawaiidesu.me/disrupt/ip.php?ip=' + config.get('instances', 'appip') )

print('Updated ' +  config.get('instances', 'appip' ))
