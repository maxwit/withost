#!/bin/sh

### FIX THE WORLD! ###

if [ $UID -ne 0 ]; then
	echo "pls run as root"
	exit 1
fi

while [ $# -gt 0 ]
do
	case $1 in
	-p|--ppm-path)
		shift
		;;
	*)
		echo -e "Invalid option '$1'\n"
		;;
	esac

	shift
done

CONF=/etc/nginx/nginx.conf

apt-get install -y nginx

grep autoindex $CONF || sed -i '/sendfile/i autoindex on;' $CONF

#systemctl restart nginx
nginx -s reload

PPM_ROOT=`awk '/^\troot/{print $2}' /etc/nginx/sites-enabled/default`
PPM_ROOT=${PPM_ROOT%;}/ppm

user=ppm
pass="Inspiry2016"
userdel -r $user
useradd -m -d $PPM_ROOT -g paipai $user
echo -e "$pass\n$pass" | passwd $user

####
#apt-get install -y nfs-kernel-server
#grep $PPM_ROOT /etc/exports || {\
#	echo "$PPM_ROOT *(rw,sync,no_subtree_check)" >> /etc/exports
#	exportfs -a
#}
