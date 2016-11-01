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

	tmp_name="/tmp/___redis"`date +%N`".conf";

	#scp $master_ip:/etc/redis.conf $tmp_name;
	ssh $master_ip touch $tmp_name;
	ssh $master_ip sudo cat /etc/redis.conf \> $tmp_name;
	scp $master_ip:$tmp_name $tmp_name;

	sed -i "s/^#\s*requirepass foobared/requirepass $master_passwd/" $tmp_name
	# FIXME: bind to internal ip address
	sed -i "s/^\(bind .*\)/#\1 /" $tmp_name

	scp $tmp_name $master_ip:$tmp_name
	ssh $master_ip sudo cp $tmp_name /etc/redis.conf
	ssh $master_ip rm $tmp_name
	rm $tmp_name

	ssh $master_ip sudo firewall-cmd --zone=public --add-port=$master_port/tcp --permanent
	ssh $master_ip sudo firewall-cmd --reload
	ssh $master_ip sudo systemctl restart redis

	for slave_ip in $3
	do
		ssh $slave_ip touch $tmp_name;
		ssh $slave_ip sudo cat /etc/redis.conf \> $tmp_name;
		scp $slave_ip:$tmp_name $tmp_name;
		sudo sed -i "s/^#\s*slaveof.*masterip.*masterport.*/slaveof $master_ip $master_port/" $tmp_name
		sudo sed -i "s/^#\s*masterauth.*/masterauth $master_passwd/" $tmp_name

		scp $tmp_name $slave_ip:$tmp_name
		ssh $slave_ip sudo cp $tmp_name /etc/redis.conf
		ssh $slave_ip rm $tmp_name
		rm $tmp_name

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

master_ip=`ssh $master /usr/sbin/ifconfig | egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" |head -1`
config $master_ip $MASTER_PORT $slaves
