#!/bin/bash

yum install -y ruby-devel sqlite-devel nodejs mysql mysql-server mysql-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

source /etc/profile.d/rvm.sh || exit 1

wget -P /tmp http://www.redmine.org/releases/redmine-2.5.2.tar.gz
tar xf /tmp/redmine-2.5.2.tar.gz -C /var/www
rm -vf /var/www/redmine
ln -sv redmine-2.5.2 /var/www/redmine

chown $SUDO_USER.nginx -R /var/www/redmine-2.5.2
# FIXME
chmod g+w -R /var/www/redmine-2.5.2

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

chown $SUDO_USER.nginx -R /var/www/redmine-2.5.2
# FIXME
chmod g+w -R /var/www/redmine-2.5.2

cd -
cp -v config/redmine.conf /etc/nginx/conf.d/
