#!/usr/bin/python

#script to start instance based on amazon linux ami

import boto3, configparser

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="alex"
f=open("dbserver.sh")
script=f.read()

ec2 = boto3.client('ec2')
instance = ec2.run_instances(
        ImageId=config.get(myconfig,"image-id"),
        MinCount=1,
        MaxCount=1,
        KeyName=config.get(myconfig,"key-name"),
        SecurityGroups=[config.get(myconfig,"security-groups")],
        InstanceType=config.get(myconfig,"instance-type"),
        UserData=script
)

print(instance)



