sudo apt-get install ruby ruby-dev rails build-essential libpq-dev
sudo gem install builder
cd ~/TeamDisrupt/webapp
bundle install
rails s -b 0.0.0.0
