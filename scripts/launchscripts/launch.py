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

        configured_ids = [config.get('instances','dbid'), config.get('instances','appid')]
        print("Terminating AWS instances")
        ec2r.instances.filter(InstanceIds=configured_ids).terminate()

        print("Removing instances from local configuration file")
        config.remove_section('instances')

print("Deploy testing? (Y/n)")
testing = False
if input() != 'n':
    testing = True
    print("Deploying Testing Servers")

#launch instances
ec2 = boto3.client('ec2')
instances = ec2.run_instances(
        ImageId=config.get(myconfig,"image-id"),
        MinCount=3,
        MaxCount=3,
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
dbserver = ec2r.Instance(ids[0])
appserver = ec2r.Instance(ids[1])
dbbackupserver = ec2r.Instance(ids[2])

#db password
#dbpass = 'hunter3'
dbpass = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.ascii_lowercase) for _ in range(20))
print('password', dbpass)

#db backup server

#save instances
config.add_section('instances')
config.set('instances','dbid',ids[0])
config.set('instances','dbip',dbserver.public_ip_address)
config.set('instances','appid',ids[1])
config.set('instances','appip',appserver.public_ip_address)
config.set('instances','backupid',ids[2])
config.set('instances','backupip',dbbackupserver.public_ip_address)
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
runcmd(dbbackupserver.public_ip_address, '"`cat gitsetup.sh`"')

if(testing):
    runcmd(dbbackupserver.public_ip_address, '"bash ~/TeamDisrupt/scripts/launchscripts/db-backup-server.sh ' + dbpass + ' ' + dbserver.public_ip_address + ' simpleref_development"')
    runcmd(appserver.public_ip_address, '"bash ~/TeamDisrupt/scripts/launchscripts/staging-server.sh ' + dbpass + ' ' + dbserver.public_ip_address + '"')
   

# Print instances IPs
print('db: {}'.format(dbserver.public_ip_address))
print('app: {}'.format(appserver.public_ip_address))
print('app running under tmux instance, connect to it at http://{}:3000',format(appserver.public_ip_address))

