#!/bin/bash

TOP=$PWD
REDMINE="redmine-2.5.2"

yum install -y ruby-devel sqlite-devel nodejs mysql mysql-server mysql-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

cd /tmp
curl -O http://www.redmine.org/releases/$REDMINE.tar.gz

tar xf $REDMINE.tar.gz -C /var/www

cd /var/www/$REDMINE

cp -v $TOP/config/database.yml config

bundle install || exit 1

# FIXME
#export RAILS_ENV=production
rake generate_secret_token
#rake db:migrate
#rake redmine:load_default_data
#RAILS_ENV=production rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data

chown $SUDO_USER.nginx -R /var/www/$REDMINE
# FIXME
chmod g+w -R /var/www/$REDMINE

rm -vf /var/www/redmine
ln -sv $REDMINE /var/www/redmine

cp -v $TOP/config/redmine.conf /etc/nginx/conf.d/
