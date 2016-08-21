#!/bin/sh
#


if [ $# -lt 2 ]; then
	echo "invalid argument;"
	echo "useage $0 master-mysql-login-id master-mysql-login-password;"
	exit 1
fi

master_user=$1
master_password=$2


read -p "slave server username: " slave_user
read -p "slave server password: " slave_password
read -p "slave server ip range: " ip_range
read -p "master server id: " master_server_id

sudo sed -i "s/^.*bind-address.*$/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
sudo sed -i "s/^.*server-id.*$/server-id=$master_server_id/" /etc/mysql/my.cnf


mysql -u$master_user -p$master_password -e "GRANT REPLICATION CLIENT,REPLICATION SLAVE ON *.* TO '$slave_user'@'$ip_range' IDENTIFIED BY '$slave_password'"

sudo service mysql restart

echo "master succeed"
