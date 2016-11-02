#!/bin/bash
###############################################################
# Script to setup database server
# Installs and configures postgres
# Run from this dir
# target: ubuntu 16.04
###############################################################

apt-get install postgresql -y

#setup postgres
#the config files allow tcp connections
cp -R ./database/root/* /

#TEST PW - DANGER!!!!
sudo -u postgres psql -c "CREATE USER pgadmin WITH PASSWORD 'SuperSecure11!'; ALTER USER pgadmin CREATEDB"
sudo -u postgres createdb pgadmin
service postgresql restart




