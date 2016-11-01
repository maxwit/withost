#!/bin/bash

while [ $# -gt 0 ]
do
	case $1 in
	-m|--master)
		master=$2
		shift
		;;
	-s|--slaves)
		slaves=(${2//,/ })
		shift
		;;
	-d|--database)
		db=$2
		shift
		;;
	*)
		echo "Invalid option '$1'"
		echo "Usage: $0 [options]"
		echo
		exit 1
		;;
	esac

	shift
done

#echo ${#slaves[@]}


MASTER_PORT=6379

install()
{
	target=$1

	ssh $target sudo yum install -y "http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"
	ssh $target sudo yum-config-manager --enable remi
	ssh $target sudo yum install -y net-tools yum-utils redis
}

config()
{
	master_ip=$1
	master_port=$2
	master_passwd="maxwit"

	redis_cfg="/etc/redis.conf"


	ssh $master_ip sudo sed -i "'s/^#\s*requirepass foobared/requirepass $master_passwd/'" $redis_cfg
	# FIXME: bind to internal ip address
	ssh $master_ip sudo sed -i "'s/^\(bind .*\)/#\1/'" $redis_cfg

	ssh $master_ip sudo firewall-cmd --zone=public --add-port=$master_port/tcp --permanent
	ssh $master_ip sudo firewall-cmd --reload
	ssh $master_ip sudo systemctl enable redis
	ssh $master_ip sudo systemctl restart redis

	for slave_ip in $3
	do
		ssh $slave_ip sudo sed -i "'s/^#\s*slaveof.*masterip.*masterport.*/slaveof $master_ip $master_port/'" $redis_cfg
		ssh $slave_ip sudo sed -i "'s/^#\s*masterauth.*/masterauth $master_passwd/'" $redis_cfg

		ssh $slave_ip sudo systemctl enable redis
		ssh $slave_ip sudo systemctl restart redis

		echo "-------------------------------------------------"
		echo "Testing slave $slave_ip: "
		ssh $master_ip redis-cli -a $master_passwd info
		ssh $slave_ip redis-cli info
	done
}

install $master
for slave in $slaves
do
	install $slave
done

master_ip=`ssh $master /usr/sbin/ip addr |egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[1-9][0-9]*" |grep "127.0.0.1|.*\..*\..*\.255" -vE|head -1`
config $master_ip $MASTER_PORT $slaves
