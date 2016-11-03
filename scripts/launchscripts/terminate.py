#!/usr/bin/python3

#script to start instance based on config file

import boto3, configparser, time, os, pickle, sys, string, random

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"
#f=open("dbserver.sh")
#script=f.read()

ec2r = boto3.resource('ec2')
#check to see if instances exist

if (config.has_section('instances')):
        print("There are instances in your config file. Do you want to terminate them? (y/N)")
        if input() != 'y':
            sys.exit()

        configured_ids = [config.get('instances','dbid'), config.get('instances','appid'), config.get('instances','backupid')]
        print("Terminating AWS instances")
        ec2r.instances.filter(InstanceIds=configured_ids).terminate()

