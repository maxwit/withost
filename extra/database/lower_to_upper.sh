#!/bin/bash
#

user=admin
password=maxwit
database=paipai

while [ $# -gt 0 ]; do
	case $1 in
	-u)
		user=$2
		shift
		;;
	-p)
		password=$2
		shift
		;;
	-d)
		database=$2
		shift
		;;
	*)
		exit 1
		;;
	esac

	shift
done

count=0
tmp=`mysql -u$user -p$password $database -e "SELECT device_id FROM tb_device;" | grep "[[:lower:]]"`
for line in $tmp; do
	mysql -u$user -p$password $database -e "UPDATE tb_device SET device_id=upper('$line') WHERE device_id='$line';"
	let count++;
done

echo "$count lines modified"
