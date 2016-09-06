#!/bin/sh

while read line
do
	record=($line)
	sup_group="devel"
	if [ ${#record[@]} = 5 ]; then
		sup_group+=",${record[4]}"
	fi

	if [ ! -e /etc/redhat-release ]; then
		sup_group=${sup_group/wheel/sudo}
	fi

	groupadd ${record[3]} 2>/dev/null
	groupadd ${record[4]%,*} 2>/dev/null
	groupadd ${record[4]#*,} 2>/dev/null

	user=${record[2]%%.*}
	useradd -m -g ${record[3]} -G $sup_group $user 2>/dev/null
	if [ $? -eq 0 ]; then
	    echo -e "\033[32m$user had added\033[0m"
	else
	    echo "$user exists"
	fi
	echo "$user:Inspiry2016" | /usr/sbin/chpasswd
done < account-list.csv
