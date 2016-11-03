#!/bin/bash
#################################################################
# Script to setup ruby on rails
# work in progress

# pgadmin password as first argument
# database ip as second argument


dbconf="# PostgreSQL. Versions 8.2 and up are supported.
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5
  username: pgadmin
  password: $1
  host: $2

development:
  <<: *default
  database: simpleref_development

test:
  <<: *default
  database: simpleref_test

production:
  <<: *default
  database: simpleref_production"

#setup db for app
cd ~/TeamDisrupt/webapp
git checkout development
rm ./config/database.yml
echo "${dbconf}" | tee ./config/database.yml

sudo apt-get install -y libsqlite3-dev ruby ruby-dev rails build-essential libpq-dev 

#redirect port 80
sudo iptables -t nat -I PREROUTING --src 0/0 -p tcp --dport 80 -j REDIRECT --to-ports 3000

#auto restart
echo "@reboot cd ~/TeamDisrupt/webapp && tmux new -d -s my-session 'rails s -b 0.0.0.0' && sudo iptables -t nat -I PREROUTING --src 0/0 -p tcp --dport 80 -j REDIRECT --to-ports 3000 " | crontab -


sudo gem install builder
bundle install

rake db:create
rake db:migrate

#run app
tmux new -d -s my-session 'rails s -b 0.0.0.0'

