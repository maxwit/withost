#!/bin/sh

while [ $# -gt 0 ]
do
	case $1 in
	-j|--jdk)
		jdk=$2
		shift
		;;
	-n|--nodes)
		nodes=$2
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

dir=`dirname $TOP`
jar=web-upgrade/target/web-upgrade-1.0-SNAPSHOT.jar

if [ ! -e $dir/nginx-local.sh ]; then
	echo "Invalid server '$server'!"
	exit 1
fi

index=1

while [ $index -le $nodes ]
do
	case $env in
	production)
		url="$server$index.2dupay.com"
		;;
	*)
		url="$server$index.$env.debug.live"
		;;
	esac

	echo "deploying $url ..."

	dst=`ssh $url mktemp -d`

	if [ -n "$jdk" ]; then
		scp $jdk $url:$dst
		# FIXME
		scp $HOME/project/wit/witjee/jdk/install-jdk.sh $url:$dst
		ssh $url sudo $dst/install-jdk.sh $dst/`basename $jdk`
	fi

	scp $jar $url:$dst
	scp $dir/node-local.sh $url:$dst/
	ssh $url sudo $dst/node-local.sh --server $server --jar $dst/`basename $jar` $env

	ssh $url rm -rf $dst

	((index++))

	echo
done
