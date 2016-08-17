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

tomcat_home=${1%/}

id=(`basename $tomcat_home | sed 's/-/ /g'`)

if [ ${#id[@]} -ne 3 -o "${id[0]}" != tomcat ]; then
	echo "'$tomcat_home' is invalid!"
	exit 1
fi

port_base=${id[1]}
url_path=${id[2]}

case $url_path in
renwoxing)
	host_name="bug.rwxlicai.com"
	;;
witweb)
	host_name="www.maxwit.com"
	;;
witp2p)
	host_name="p2p.maxwit.com"
	;;
*)
	echo "not supported!"
	exit 1
	;;
esac

./tomcat-setup.sh --tomcat-home $tomcat_home --port-base $port_base || exit 1
sudo ./httpd-setup.sh --host-name $host_name --cluster-list 127.0.0.1:${port_base}080 --url-path $url_path
