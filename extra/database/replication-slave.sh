#!/bin/bash


sed -i "s/^.*server-id.*$/server-id = 10/" /etc/mysql/my.cnf
sed -i "s/^.*log_bin.*$/#&/" /etc/mysql/my.cnf
sed -i "s/^#relay_log/relay_log/" /etc/mysql/my.cnf
sed -i "s/^.*read_only/read_only/" /etc/mysql/my.cnf

service mysql restart

mysql -uroot -p123456 -e "CHANGE MASTER TO \
			MASTER_HOST='192.168.0.124',\
			MASTER_USER='dm', \
			MASTER_PASSWORD='123456', \
			MASTER_LOG_FILE='mariadb-bin.000001', \
			MASTER_LOG_POS=4, \
			MASTER_CONNECT_RETRY=5, \
			MASTER_HEARTBEAT_PERIOD=2;"

mysql -uroot -p123456 -e "START SLAVE;"
mysql -uroot -p123456 -e "SHOW SLAVE STATUS\G"
