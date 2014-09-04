#!/bin/bash

#yum install -y httpd-devel ruby-devel sqlite-devel nodejs mariadb mariadb-server mariadb-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

yum install -y nodejs ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

#
echo "installing passenger..."
gem install -N passenger || exit 1

useradd --no-create-home --system --shell /sbin/nologin nginx
usermod -a -G nginx $USER

# --nginx-source-dir=
passenger-install-nginx-module \
	--auto \
	--prefix=/usr/nginx \
	--auto-download \
	--extra-configure-flags="--sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --user=nginx --group=nginx" \
	--languages "ruby,python,nodejs"

mkdir -p /etc/nginx/conf.d/
sed -i.orig '$i'"\ \ \ \ include /etc/nginx/conf.d/*.conf;" /etc/nginx/nginx.conf

echo "installing rails ..."
yum install -y ruby-devel sqlite-devel nodejs mysql mysql-server mysql-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison
gem install -N rails || exit 1

echo "Please re-login now!!!"
