#!/bin/bash
###############################################################
# Script to setup database server
# Installs and configures postgres
# target: ubuntu 16.04
# need to run gitsetup script first
###############################################################



#pass password for pgadmin as first argument

sudo apt-get install postgresql -y

#setup postgres
#the config files allow tcp connections
#assumes repo is already there
sudo cp -R /home/ubuntu/TeamDisrupt/database/root/* /

#TEST PW - DANGER!!!!
sudo -u postgres psql -c "CREATE USER pgadmin WITH PASSWORD '$1'; ALTER USER pgadmin CREATEDB"
sudo -u postgres createdb pgadmin
sudo service postgresql restart




