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
	-s|--plat)
		plat=$2
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

app="paipai-$plat"
if [ $env != 'production' ]; then
	app="$app-$env"
fi

# FIXME
if [ -e /etc/init.d/$app ]; then
	service $app stop
fi

cp $jar /opt/$app.jar || exit 1
chown $user.$user /opt/$app.jar

if [ ! -e /etc/init.d/$app ]; then
	ln -sfv /opt/$app.jar /etc/init.d/$app
	update-rc.d $app defaults 88
fi

service $app start

#case $env in
#local)
#	url="localhost"
#	;;
#production)
#	url="$plat.2dupay.com"
#	;;
#*)
#	url="$plat.$env.2dupay.com"
#	;;
#esac
#
#grep $ppm_path /etc/fstab || {
#	mkdir -p /mnt/ppm
#	echo "$url:$ppm_path /mnt/ppm nfs defaults 0 0" >> /etc/fstab
#}
