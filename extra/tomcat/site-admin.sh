#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "pls run as root!"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "usage: $0 <site>"
	exit 1
fi

site="$1"

sed "s/__SITE__/$site/g" site-template.conf > /etc/nginx/conf.d/$site.conf
