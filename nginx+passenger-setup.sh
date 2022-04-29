#!/bin/bash

echo "Enter application environment(i.e development or production)"
read environment

echo "Enter full project path (like /home/ubuntu/exampleproject/public)"
read path

sudo apt-get update

sudo apt-get install -y nginx 

sudo apt-get install -y nginx-extras 

sudo service nginx start

sudo apt-get install -y dirmngr gnupg

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

sudo apt-get install -y apt-transport-https ca-certificates

#Add our APT repository
echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main" | sudo tee /etc/apt/sources.list.d/passenger.list

sudo apt-get update

#install nginx  +passenger module
sudo apt-get install -y libnginx-mod-http-passenger

if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load/etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi

sudo ls /etc/nginx/conf.d/mod-http-passenger.conf

sudo service nginx restart

sudo /usr/bin/passenger-config validate-install

sudo /usr/sbin/passenger-memory-stats

sudo apt install -y curl

passenger-config about ruby-command

#update line in the /etc/nginx/conf.d/mod-http-passenger.conf file and replace ruby path

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
