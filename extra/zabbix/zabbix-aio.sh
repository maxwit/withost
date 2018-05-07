#!/usr/bin/env bash

# install zabbix server
wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb
dpkg -i zabbix-release_3.4-1+xenial_all.deb
apt update

apt-get install -y zabbix-server-mysql
apt-get install -y zabbix-frontend-php

mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"

zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uzabbix -pzabbix zabbix

sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

systemctl start zabbix-server
update-rc.d zabbix-server enable

sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Shanghai/' /etc/apache2/conf-enabled/zabbix.conf

systemctl restart apache2

# install zabbix agent
apt-get install -y zabbix-agent
systemctl start zabbix-agent
