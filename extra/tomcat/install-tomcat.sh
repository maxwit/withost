#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "pls run as root!"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "usage: $0 <tomcat>"
	exit 1
fi

pkg=$1

tc=`basename $pkg`
tc=${tc%.tar.*}

echo "installing $tc ..."

tar xvf $pkg -C /opt || exit 1

mkdir -p /opt/share
useradd -m -d /opt/share/tomcat tomcat
chown -R tomcat.tomcat -R /opt/$tc

cp tomcat.service /etc/init.d/tomcat
