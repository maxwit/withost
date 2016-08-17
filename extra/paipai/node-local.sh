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
	-j|--jar)
		jar=$2
		shift
		;;
#	-p|--ppm-path)
#		ppm_path=$2
#		shift
#		;;
	-s|--server)
		server=$2
		shift
		;;
	*)
		echo -e "Invalid option '$1'\n"
		exit 1
		;;
	esac

	shift
done

user=paipai
home=/var/lib/$user

if [ ! -e $home ]; then
	useradd -r -m -d $home $user
fi

service="paipai-$server"
if [ $env != 'production' ]; then
	service="$service-$env"
fi

# FIXME
if [ -e /etc/init.d/$service ]; then
	service $service stop
fi

cp $jar /opt/$service.jar || exit 1
chown $user.$user /opt/$service.jar

if [ ! -e /etc/init.d/$service ]; then
	ln -sfv /opt/$service.jar /etc/init.d/$service
	update-rc.d $service defaults 88
fi

service $service start

case $env in
local)
	url="localhost"
	;;
production)
	url="$server.2dupay.com"
	;;
*)
	url="$server.$env.2dupay.com"
	;;
esac

#grep $ppm_path /etc/fstab || {
#	mkdir -p /mnt/ppm
#	echo "$url:$ppm_path /mnt/ppm nfs defaults 0 0" >> /etc/fstab
#}
