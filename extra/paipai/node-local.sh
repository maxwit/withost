#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "pls run as root"
	exit 1
fi

while [ $# -gt 0 ]
do
	case $1 in
	-j|--jar)
		jar=$2
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
		env=$1
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

cp $jar /opt/$service.jar || exit 1
chown $user.$user /opt/$service.jar

if [ ! -e /etc/init.d/$service ]; then
	ln -sfv /opt/$service.jar /etc/init.d/$service
	update-rc.d $service defaults 88
fi
