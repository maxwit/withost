#!/bin/sh

env=devel
nodes=2
server=dm

dir=`dirname $0`

while [ $# -gt 0 ]
do
	case $1 in
	-e|--env)
		env=$2
		shift
		;;
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
	*)
		echo "Invalid option '$1'"
		echo "Usage: $0 [options] <env>"
		echo
		exit 1
		;;
	esac

	shift
done

case $env in
production)
	url="$server.2dupay.com"
	;;
devel|testing|staging)
	url="$server.$env.2dupay.com"
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

node_list=""
index=1

while [ $index -le $nodes ]
do
	case $env in
	production)
		url_tmp="$server$index.2dupay.com"
		;;
	*)
		url_tmp="$server$index.$env.2dupay.com"
		;;
	esac

	dst_tmp=`ssh $url_tmp mktemp -d`
	scp $dir/get-ip.sh $url_tmp:$dst_tmp
	ip=`ssh $url_tmp $dst_tmp/get-ip.sh`
	ssh $url_tmp rm -rf $dst_tmp

	node_list="$node_list $ip"

	((index++))
done

scp $dir/nginx-local.sh $url:$dst
ssh $url sudo $dst/nginx-local.sh --server $server --env $env $node_list

ssh $url rm -rf $dst

if [ -n "$jdk" ]; then
	jdk_opt="--jdk $jdk"
fi

$dir/deploy-nodes.sh --server $server --nodes $nodes --env $env $jdk_opt

echo
