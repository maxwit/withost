#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 <env>"
	exit 1
fi

env=$1

for host in dm dm1 dm2 sp up
do
	if [ $env = 'production' ]; then
		url="$host.2dupay.com"
	else
		url="$host.$env.debug.live"
	fi

	case $host in
	dm[1-9])
		setup=dm-node-setup.sh
		;;
	*)
		setup=${host}-setup.sh
		;;
	esac

	if [ ! -e $setup ]; then
		echo "'$setup' does NOT exists! (skipped)"
		continue
	fi

	echo deploying $url ...
done
