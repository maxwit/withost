if [ $UID -eq 0 ]; then
	echo "pls run as root"
	exit 1
fi

HUSER=tomcat
CONF=/etc/nginx/nginx.conf

PPM_ROOT=/var/www/html/ppm

apt install -y nginx
grep autoindex $CONF || sed -i '/sendfile/i autoindex on;' $CONF
systemctl restart nginx

groupadd inspiry
useradd -g inspiry $HUSER
mkdir -p $PPM_ROOT
chown $HUSER $PPM_ROOT

apt install -y openssh-server
