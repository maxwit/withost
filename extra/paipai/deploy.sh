#!/bin/sh

nodes=2
server=dm

dir=`dirname $TOP`

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
		echo "Invalid option '$1'"
		echo "Usage: $0 [options] <env>"
		echo
		exit 1
		;;
	*)
		env=$1
		;;
	esac

	shift
done

case $env in
production)
	url="$server.2dupay.com"
	;;
devel|testing|staging)
	url="$server.$env.debug.live"
	;;
*)
	echo "invalid environment '$env'!"
	exit 1
esac

echo "deploying $url ..."

dst=`ssh $url mktemp -d`

if [ ! -x $dir/nginx-local.sh ]; then
	echo "Invalid!"
	exit 1
fi

scp $dir/nginx-local.sh $url:$dst
ssh $url sudo $dst/nginx-local.sh --server $server --nodes $nodes $env

ssh $url rm -rf $dst

if [ -n "$jdk" ]; then
	jdk_opt="--jdk $jdk"
fi

$dir/deploy-nodes.sh --server $server --nodes $nodes $jdk_opt $env

echo
