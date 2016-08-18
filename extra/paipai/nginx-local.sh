#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "pls run as root"
	exit 1
fi

while [ $# -gt 0 ]
do
	case $1 in
	--env)
		env=$2
		shift
		;;
	--server-name)
		server_name=$2
		shift
		;;
	--plat)
		plat=$2
		shift
		;;
	--port)
		port=$2
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

if [ $env = production ]; then
	conf=$conf_dir/$plat-http.conf
	balancer=$plat-nodes
else
	conf=$conf_dir/$plat-$env-http.conf
	balancer=$plat-$env-nodes
fi

echo "upstream $balancer {" > $conf

for node in ${node_list[@]}
do
	echo -e "\tserver $node:$port;" >> $conf
done

cat >> $conf << _EOF_
}

server {
	listen 80;
	server_name $server_name;

	location / {
		proxy_pass http://$balancer/;

		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection \$connection_upgrade;
	}
}

map \$http_upgrade \$connection_upgrade {
    default upgrade;
    ''      close;
}
_EOF_

if [ -d '/etc/nginx/sites-enabled' ]; then
	ln -svf $conf /etc/nginx/sites-enabled
fi

nginx -s reload

echo
