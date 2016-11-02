#!/bin/bash
###############################################################
# Script to setup database server
# Installs and configures postgres
# Run from this dir
# target: ubuntu 16.04
###############################################################

#pass password for pgadmin as first argument

sudo apt-get install postgresql -y

#setup postgres
#the config files allow tcp connections
sudo cp -R ./database/root/* /

#TEST PW - DANGER!!!!
sudo -u postgres psql -c "CREATE USER pgadmin WITH PASSWORD '$1'; ALTER USER pgadmin CREATEDB"
sudo -u postgres createdb pgadmin
sudo service postgresql restart




