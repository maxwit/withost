#!/bin/bash

#sudo yum install -y httpd-devel ruby-devel sqlite-devel nodejs mariadb mariadb-server mariadb-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

yum install -y sqlite-devel nodejs mysql mysql-server mysql-devel ImageMagick-devel tk tk-devel curl-devel pcre-devel libyaml-devel libffi-devel gcc-c++ readline-devel openssl-devel libtool bison

wget http:/xxx/ruby-x
tar xvf

./configure --prefix=/usr && make && make install

gem source -a https://ruby.taobao.org
gem source -l
