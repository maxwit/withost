#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "pls run as root!"
	exit 1
fi

conf_file="/etc/nginx/nginx.conf"
cluster_list="127.0.0.1:8080"

while [ $# -gt 0 ]
do
	case $1 in
	-c|--conf-file)
		conf_file=$2
		shift
		;;
	-n|--host-name)
		host_name=$2
		shift
		;;
	-l|--cluster-list)
		cluster_list=$2
		shift
		;;
	-p|--url-path)
		url_path=$2
		shift
		;;
	*)
		echo -e "Invalid option '$1'\n"
		exit 1
		;;
	esac

	shift
done

if [ -z "$host_name" ]; then
	echo "usage: xxx"
	exit 1
fi

http_home=`dirname $conf_file`
site_id=${host_name//./-}
cluster_id="cluster-$site_id"

if [ -z "$url_path" ]; then
	proxy="http://$cluster_id"
else
	proxy="http://$cluster_id/$url_path/"
fi

cat > $http_home/conf.d/$site_id.conf << EOF
upstream $cluster_id {
    server $cluster_list fail_timeout=0;
}

server {
    listen 80;
    server_name $host_name;

    location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$http_host;
        proxy_redirect off;

        proxy_pass $proxy;
    }
}
EOF
