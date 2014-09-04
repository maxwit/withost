#!/bin/bash

#sudo yum install -y httpd-devel ruby-devel sqlite-devel nodejs mariadb mariadb-server mariadb-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

yum install -y ruby-devel sqlite-devel nodejs mysql mysql-server mysql-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

curl -sSL https://get.rvm.io | sudo bash -s stable --ruby || exit 1
# TODO: auto loaded when login?
source /etc/profile.d/rvm.sh || exit 1
sudo usermod -a -G rvm $USER

rvmsudo gem source -a https://ruby.taobao.org
rvmsudo gem source -l
