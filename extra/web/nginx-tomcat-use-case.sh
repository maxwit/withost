#!/bin/sh

if [ $UID -eq 0 ]; then
	echo "do NOT run as root!"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "usage: $0 <site>"
	exit 1
fi

cd `dirname $0`

id=$1

tomcat_home=/opt/tomcat-$id
if [ $id = witweb ]; then
	port_base=11
elif [ $id = renwoxing ]; then
	port_base=12
else
	port_base=13
fi
url_path=$id

host_name="www.${id}.com"

./tomcat-setup.sh --tomcat-home $tomcat_home --port-base $port_base || exit 1
sudo ./httpd-admin.sh --host-name $host_name --cluster-list 127.0.0.1:${port_base}080 --url-path $url_path
