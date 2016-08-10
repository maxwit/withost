#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "pls run as root"
	exit 1
fi

while [ $# -gt 0 ]
do
	case $1 in
	-e|--env)
		env=$2
		shift
		;;
	-s|--server)
		server=$2
		shift
		;;
	-*)
		echo -e "Invalid option '$1'\n"
		exit 1
		;;
	*)
		node_list=($@)
		break
		;;
	esac

	shift
done

which nginx || \
if [ -e /etc/redhat-release ]; then
	yum install -y nginx

	which systemctl > /dev/null \
		&& systemctl enable nginx \
		|| chkconfig nginx on
else
	apt-get install -y nginx
fi

if [ -d '/etc/nginx/sites-available' ]; then
	conf_dir='/etc/nginx/sites-available'
elif [ -d '/etc/nginx/conf.d' ]; then
	conf_dir='/etc/nginx/conf.d'
else
	echo "distribution not supported!"
	exit 1
fi

if [ $server = dm ]; then
	base=11
else
	base=21
fi

for e in local devel testing staging production
do
	if [ $env = $e ]; then
		port=${base}080
		break
	fi

	((base++))
done

#upstream dm-server {
#	server dm1.2dupay.com:8080;
#	server dm2.2dupay.com:8080;
#}
#
#server {
#	listen 80;
#	server_name dm.2dupay.com;
#
#	location / {
#		proxy_pass http://dm-server/;
#	}
#}

conf=$conf_dir/$server-http.conf

balancer=$server-nodes

echo "upstream $balancer {" > $conf

for ip in ${node_list[@]}
do
	echo -e "\tserver $ip:$port;" >> $conf
done

cat >> $conf << _EOF_
}

server {
	listen 80;
	server_name $server.2dupay.com;

	location / {
		proxy_pass http://$balancer/;
	}
}
_EOF_

if [ -d '/etc/nginx/sites-enabled' ]; then
	ln -svf $conf /etc/nginx/sites-enabled
fi

echo
