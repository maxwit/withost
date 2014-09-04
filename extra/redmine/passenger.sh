#!/bin/bash

#sudo yum install -y httpd-devel ruby-devel sqlite-devel nodejs mariadb mariadb-server mariadb-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison
sudo yum install -y ruby-devel sqlite-devel nodejs mysql mysql-server mysql-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

curl -sSL https://get.rvm.io | sudo bash -s stable --ruby || exit 1
# TODO: auto loaded when login?
source /etc/profile.d/rvm.sh || exit 1
export rvmsudo_secure_path=1
sudo usermod -a -G rvm $USER
# rvm use 2.1.2

rvmsudo gem source -a https://ruby.taobao.org
rvmsudo gem source -l

#
echo "installing passenger and rails ..."
rvmsudo gem install passenger rails || exit 1

sudo useradd --no-create-home --system nginx
sudo usermod -a -G nginx $USER

# --nginx-source-dir=
rvmsudo passenger-install-nginx-module \
	--auto \
	--prefix=/usr/nginx \
	--auto-download \
	--extra-configure-flags="--sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --user=nginx --group=nginx" \
	--languages "ruby,python,nodejs"

sudo mkdir -p /etc/nginx/conf.d/
sudo sed -i.orig '$i'"\ \ \ \ include /etc/nginx/conf.d/*.conf;" /etc/nginx/nginx.conf

echo "Please re-login now!!!"
