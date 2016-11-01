#!/bin/bash

master='dm1.local.2dupay.com'
slave='dm2.local.2dupay.com'
database='paipai'

master_user='root'
master_pw='maxwit'
master_server_id=10
slave_user='root'
slave_pw='maxwit'
master_slave_user='replication'
master_slave_pw='maxwit'
slave_server_id=20

pos=0

while [ $# -gt 0 ]
do
	case $1 in
	-m|--master)
		master=$2
		shift
		;;
	-s|--slave)
		slave=$2
		shift
		;;
	-d|--database)
		database=$2
		shift
		;;
	*)
		echo "invalid argument $1"
		exit 1
		;;
	esac
	shift
done

ssh $master 'date' && ssh $slave 'date'
if [ $? -ne 0 ];then
	echo "you need build trust first"
	exit 2
fi

master_ip=`ssh $master /usr/sbin/ifconfig | grep inet | head -1 | awk -F' ' '{print $2}'`
slave_ip=`ssh $slave /usr/sbin/ifconfig | grep inet | head -1 | awk -F' ' '{print $2}'`

#master 
status=`ssh $master sudo firewall-cmd --zone=public --query-port=3306/tcp`
if [ "$status" = "no" ]; then
	ssh $master sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
	ssh $master sudo firewall-cmd --reload
fi

ssh $master sudo cp -f /etc/my.cnf /etc/my.cnf.bak
ssh $master sudo cp /usr/share/mysql/my-small.cnf /etc/my.cnf
ssh $master sudo sed -i "s/^.*bind-address.*$/bind-address = $master_ip/" /etc/my.cnf
ssh $master sudo sed -i "s/^.*server-id.*$/server-id=$master_server_id/" /etc/my.cnf
ssh $master sudo sed -i "s/^.*log-bin.*$/log-bin=mysql-bin/" /etc/my.cnf
ssh $master sudo sed -i "/log-bin=mysql-bin/a binlog-do-db=$database" /etc/my.cnf
mastertmp1=`mktemp`
echo -e "sudo sed -i \"/log-bin=mysql-bin/a binlog-do-db=$database\" /etc/my.cnf" > $mastertmp1
scp $mastertmp1 $master:/tmp
ssh $master bash $mastertmp1
ssh $master rm $mastertmp1
rm $mastertmp1

mastertmp2=`mktemp`
echo -e "GRANT REPLICATION CLIENT,REPLICATION SLAVE ON *.* TO '$master_slave_user'@'$slave_ip' IDENTIFIED BY '$master_slave_pw';" > $mastertmp2
scp $mastertmp2 $master:/tmp
ssh $master mysql -u$master_user -p$master_pw < $mastertmp2
ssh $master rm $mastertmp2
rm $mastertmp2


ssh $master sudo service mariadb restart

#master bin-log analisys
ls /var/lib/mysql/

#slave
ssh $slave sudo cp -f /etc/my.cnf /etc/my.cnf.bak
ssh $slave sudo cp /usr/share/mysql/my-small.cnf /etc/my.cnf
ssh $slave sudo sed -i "s/^.*server-id.*$/server-id=$slave_server_id/" /etc/my.cnf
ssh $slave sudo sed -i "s/^.*log-bin.*$/# log-bin=mysql-bin/" /etc/my.cnf
slavetmp1=`mktemp`
echo -e "sudo sed -i \"/log-bin=mysql-bin/a relay-log=mysql-relay-log\" /etc/my.cnf" >> $slavetmp1
echo -e "sudo sed -i \"/log-bin=mysql-bin/a read-only\" /etc/my.cnf" >> $slavetmp1
scp $slavetmp1 $slave:/tmp
ssh $slave bash $slavetmp1
ssh $slave rm $slavetmp1
rm $slavetmp1
ssh $slave sudo service mariadb restart

slavetmp2=`mktemp`
echo -e "STOP SLAVE;RESET SLAVE;
			CHANGE MASTER TO \
            MASTER_HOST='$master_ip',\
            MASTER_USER='$master_slave_user', \
            MASTER_PASSWORD='$master_slave_pw', \
            MASTER_LOG_FILE='mysql-bin.000001', \
            MASTER_LOG_POS=4, \
            MASTER_CONNECT_RETRY=5, \
            MASTER_HEARTBEAT_PERIOD=2;
			START SLAVE;
			SHOW SLAVE STATUS;" > $slavetmp2
scp $slavetmp2 $slave:/tmp
ssh $slave mysql -u$slave_user -p$slave_pw <$slavetmp2
ssh $slave rm $slavetmp2
rm $slavetmp2
