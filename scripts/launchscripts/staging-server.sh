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
  database: simpleref_production
  username: simpleref
  password: <%= ENV['SIMPLEREF_DATABASE_PASSWORD'] %>"

#setup db for app
cd ~/TeamDisrupt/webapp
rm ./config/database.yml
echo "${dbconf}" | tee ./config/database.yml

sudo apt-get install -y libsqlite3-dev ruby ruby-dev rails build-essential libpq-dev 

sudo gem install builder
git checkout development
bundle install

rake db:create
rake db:migrate


rails s -b 0.0.0.0
