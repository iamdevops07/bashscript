#First copy this file, where you want to setup ror
#after run :-  chmod u+x rorsetup.sh 
#now run script by:-  .rorsetup.sh

#!/bin/bash

echo "Enter version of ruby (if you want versino 2.4.0 write 2.4.0)"
read rubyversion

echo "Enter version of rails (if you want versino 6.0.0 write 6.0.0)"
read railsversion

echo "Enter application environment(i.e development or production)"
read environment

echo "Enter full project path (like /home/ubuntu/exampleproject/public)"
read path

################### Nginx and passenger installation ###################

sudo apt-get update

sudo apt-get install -y nginx 

sudo apt-get install -y nginx-extras 

sudo service nginx start

sudo apt-get install -y dirmngr gnupg

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

sudo apt-get install -y apt-transport-https ca-certificates

#Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'

sudo apt-get update

#install nginx  +passenger module
sudo apt-get install -y libnginx-mod-http-passenger

if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load/etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

sudo ls /etc/nginx/conf.d/mod-http-passenger.conf

sudo service nginx restart

sudo /usr/bin/passenger-config validate-install

sudo /usr/sbin/passenger-memory-stats

sudo apt install -y curl 

##################################### Installing ruby on rails ####################################################

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update

sudo apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn  

sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

sudo apt-get update

sudo apt-get install -y gnupg2

gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io -o rvm.sh

cat rvm.sh | bash -s stable --rails

source ~/.rvm/scripts/rvm

rvm install $rubyversion

rvm use $rubyversion --default

ruby -v

gem install bundler

gem install rails -v $railsversion

################################ Setup Nginx ##############################

sudo echo "" >> /etc/nginx/conf.d/mod-http-passenger.conf

sudo echo "
### Begin automatically installed Phusion Passenger config snippet ###
passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /home/ubuntu/.rvm/gems/ruby-$rubyversion/wrappers/ruby;
### End automatically installed Phusion Passenger config snippet ### 
" >> /etc/nginx/conf.d/mod-http-passenger.conf

sudo echo "" >> /etc/nginx/sites-enabled/default

sudo echo "server {
    listen 80;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root $path;

    # Turn on Passenger
    passenger_enabled on;
    passenger_app_env $environment;
}
" >> /etc/nginx/site-enabled/default

sudo nginx -t

sudo service nginx restart
