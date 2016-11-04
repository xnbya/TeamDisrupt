# Documentation

## Install Ansible

Install dependencies:

```sh
sudo pip install paramiko PyYAML Jinja2 httplib2 six
```

Clone the ansible repository and source the environment variables:

```sh
git clone git://github.com/ansible/ansible.git --recursive
cd ./ansible
source ./hacking/env-setup
```

## Configure Ansible to work with AWS

Ansible works against multiple systems in your infrastructure at the same time.
It normally does this by selecting portions of systems listed in Ansible’s
inventory file, which defaults to being saved in the location
`/etc/ansible/hosts`. You can specify a different inventory file using the `-i
<path>` option on the command line.

However, since we will be using Amazon Web Services EC2, maintaining an
inventory file is not the best approach, because hosts may come and go over
time, be managed by external applications etc. For this reason, we will be using
a *dynamic inventory* through the [EC2 external inventory
script](https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py).

### Create IAM user on AWS console

Log into your AWS Console and go to the IAM (Identity and Access Management)
service.

Go to Users and create a user named `ansible`. Make sure to
tick the box to generate an access key for that user.

Download those credentials somewhere on your machine. You will not be able to
download them at a later time.

Go to Groups and create a group named `automatic-provisioning`. For simplicity,
we'll pick the `Power User Access` policy, but you might actually want to pick
more granular permissions in a normal set up.

Then go to Group Actions and add the `ansible` user to the
`automatic-provisioning` group.

### Configure Boto

Boto is the Python interface to Amazon Web Services, which ansible's `ec2.py`
uses internally.

Create a `~/.boto` file to store your credentials (from the credentials file you
downloaded earlier):

```
[credentials]
aws_access_key_id = <your_access_key_here>
aws_secret_access_key = <your_secret_key_here>
```

You may need to `source ./hacking/env-setup` again for this to take effect.

## Create an AWS keypair and set it up locally

Log into your AWS Console and go to the EC2 service, under the Network &
Security heading.

Create a new Key Pair and save it in your `~/.ssh/` folder.

### Configure permissions and add to ssh-agent

```sh
chmod +600 ~/.ssh/keypair.pem
ssh-agent bash
ssh-add ~/.ssh/keypair.pem
```

## Playbooks

### Spinning up an EC2 instance

This is provided in the `ec2-instance` role.

### PostgreSQL

https://galaxy.ansible.com/ANXS/postgresql/

```sh
sudo su
source <path-to-ansible>/hacking/env-setup
ansible-galaxy install ANXS.postgresql
exit
```

### Ruby

https://galaxy.ansible.com/rvm_io/rvm1-ruby/

```sh
sudo su
source <path-to-ansible>/hacking/env-setup
ansible-galaxy install rvm_io.rvm1-ruby
exit
```

sudo rm /home/dranov/ansible/lib//ansible.egg-info/*
