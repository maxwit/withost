#!/bin/sh

### FIX THE WORLD! ###

if [ $UID -ne 0 ]; then
	echo "pls run as root"
	exit 1
fi

dir=/var/www/html/ppm

while [ $# -gt 0 ]
do
	case $1 in
	-p|--ppm-path)
		dir=$2
		shift
		;;
	*)
		echo -e "Invalid option '$1'\n"
		;;
	esac

	shift
done

CONF=`awk '/^\troot/{print $2}' /etc/nginx/sites-enabled/default`
CONF=${CONF%;}
echo $CONF
exit

apt-get install -y nginx

grep autoindex $CONF || sed -i '/sendfile/i autoindex on;' $CONF

#systemctl restart nginx
nginx -s reload

PPM_ROOT=`awk '/^\troot/{print $2}' /etc/nginx/sites-enabled/default`
PPM_ROOT=${PPM_ROOT%;}

mkdir -p $PPM_ROOT

user=ppm
pass="Inspiry2016"

# FIXME
useradd -m -g paipai $user
echo -e "$pass\n$pass" | passwd $user

chown $user $PPM_ROOT

####
#apt-get install -y nfs-kernel-server
#grep $PPM_ROOT /etc/exports || {\
#	echo "$PPM_ROOT *(rw,sync,no_subtree_check)" >> /etc/exports
#	exportfs -a
#}
