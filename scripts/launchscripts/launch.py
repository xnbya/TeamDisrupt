#!/usr/bin/python3

#script to start instance based on config file

import boto3, configparser, time, os, pickle, sys, string, random

#load config for ec2 instance
config = configparser.ConfigParser()
config.read('ec2config.ini')
myconfig="ec2conf"
#f=open("dbserver.sh")
#script=f.read()

#check to see if instances exist
if (config.has_section('instances')):
        print("Instances exist, continue? (y/N)")
        if input() != 'y':
            sys.exit()
        config.remove_section('instances')
    

#launch instances
ec2 = boto3.client('ec2')
instances = ec2.run_instances(
        ImageId=config.get(myconfig,"image-id"),
        MinCount=2,
        MaxCount=2,
        KeyName=config.get(myconfig,"key-name"),
        SecurityGroups=[config.get(myconfig,"security-groups")],
        InstanceType=config.get(myconfig,"instance-type")
        #UserData=script
)

#print(instances)
ids =[]
for instance in instances['Instances']:
    #print(instance)
    print("ID is",instance['InstanceId'])
    ids.append(instance['InstanceId'])

print('wait for instances to boot up')
waiter = ec2.get_waiter('instance_status_ok')
waiter.wait(InstanceIds=ids)

print('Instances running')

#get IPs
ec2r = boto3.resource('ec2')
dbserver = ec2r.Instance(ids[0])
print('dbserver ip: ' + dbserver.public_ip_address)

appserver = ec2r.Instance(ids[1])
print('appserver ip:' + appserver.public_ip_address)

#db password
#dbpass = 'hunter3'
dbpass = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.ascii_lowercase) for _ in range(20))
print('password', dbpass)

#save instances
config.add_section('instances')
config.set('instances','dbid',ids[0])
config.set('instances','dbip',dbserver.public_ip_address)
config.set('instances','aopid',ids[1])
config.set('instances','appip',appserver.public_ip_address)
config.set('instances','dbpass',dbpass)
conffile = open('ec2config.ini', 'w')
config.write(conffile)
conffile.close()


print('setting up database server')

def runcmd(servip, command):
    os.system('ssh -oStrictHostKeyChecking=no -i ' + config.get(myconfig, "key-location") + ' ubuntu@' + servip + " " + command )

runcmd(dbserver.public_ip_address, '"`cat gitsetup.sh`"')
print("GIT setup")
runcmd(dbserver.public_ip_address, '"bash ~/TeamDisrupt/scripts/launchscripts/db-server.sh ' + dbpass + '"')

print("DB server setup, starting appserver")

runcmd(appserver.public_ip_address, '"`cat gitsetup.sh`"')

print('appserver ip:' + appserver.public_ip_address)
runcmd(appserver.public_ip_address, '"bash ~/TeamDisrupt/scripts/launchscripts/staging-server.sh ' + dbpass + ' ' + dbserver.public_ip_address + '"')

