#!/bin/bash

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
	-a|--app)
		jar=$2
		shift
		;;
	--port)
		port=$2
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
if [ $env = 'production' ]; then
	mem=2G
else
	app="$app-$env"
	mem=512M
fi

app_path=/opt/$app
mkdir -p $app_path

# FIXME
if [ -e /etc/init.d/$app ]; then
	service $app stop
fi

cp $jar $app_path/$app.jar || exit 1
chown $user.$user $app_path/$app.jar

if [ -e /etc/init.d/$app ]; then
	lnk=`readlink /etc/init.d/$app`
	if [ "$lnk" != $app_path/$app.jar ]; then
		rm -v $lnk
		ln -sfv $app_path/$app.jar /etc/init.d/$app
	fi
else
	ln -sv $app_path/$app.jar /etc/init.d/$app
	update-rc.d $app defaults 88
fi

cat > $app_path/$app.conf << _EOF_
JAVA_OPTS=-Xmx$mem
RUN_ARGS="--server.port=$port --spring.profiles.active=$env"
_EOF_

echo "[$app_path/$app.conf]"
cat $app_path/$app.conf

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
