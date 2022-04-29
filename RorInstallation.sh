#!/bin/bash

echo "Enter version of ruby (if you want versino 2.4.0 write 2.4.0)"
read rubyversion

echo "Enter version of rails (if you want versino 6.0.0 write 6.0.0)"
read railsversion

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

source /home/ubuntu/.rvm/scripts/rvm

rvm install $rubyversion

rvm use $rubyversion --default

ruby -v

gem install bundler

gem install rails -v $railsversion
