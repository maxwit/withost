#!/bin/bash

source /etc/profile.d/rvm.sh || exit 1

sudo wget -P /tmp http://www.redmine.org/releases/redmine-2.5.2.tar.gz
sudo tar xf /tmp/redmine-2.5.2.tar.gz -C /var/www
sudo rm -vf /var/www/redmine
sudo ln -sv redmine-2.5.2 /var/www/redmine

sudo chown $USER.nginx -R /var/www/redmine-2.5.2
# FIXME
sudo chmod g+w -R /var/www/redmine-2.5.2

cp -v config/database.yml /var/www/redmine-2.5.2/config
cd /var/www/redmine-2.5.2

bundle install || exit 1

# FIXME
#export RAILS_ENV=production
rake generate_secret_token
#rake db:migrate
#rake redmine:load_default_data
#RAILS_ENV=production rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data

sudo chown $USER.nginx -R /var/www/redmine-2.5.2
# FIXME
sudo chmod g+w -R /var/www/redmine-2.5.2

sudo cp -v config/redmine.conf /etc/nginx/conf.d/
