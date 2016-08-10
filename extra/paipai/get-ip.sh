#!/bin/sh

if [ -e /usr/sbin/aliyun-service ]; then
	cmd="ifconfig eth0"
else
	cmd="ifconfig"
fi

$cmd | grep 'inet addr' | head -1 | awk '{print $2}' | awk -F':' '{print $2}'
