#!/bin/sh

env='local'
nodes=1

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
	*)
		echo "Invalid option '$1'"
		echo "Usage: $0 [options] <env>"
		echo
		exit 1
		;;
	esac

	shift
done

if [ ! -e pom.xml ]; then
	echo "pls run the program inside a maven project!"
	exit 1
fi

if grep dm-parent pom.xml > /dev/null; then
	server=dm
elif grep sp-parent pom.xml > /dev/null; then
	server=sp
else
	echo "project not supported!"
	exit 1
fi

case $env in
local)
	url="localhost"
	;;
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
	local)
		node="127.0.0.1"
		;;
	production)
		node="$server$index.2dupay.com"
		;;
	*)
		node="$server$index.$env.2dupay.com"
		;;
	esac

	if [ $env = production ]; then
		dst_tmp=`ssh $node mktemp -d`
		scp $dir/get-ip.sh $node:$dst_tmp
		node=`ssh $node $dst_tmp/get-ip.sh`
		ssh $node rm -rf $dst_tmp
	fi

	node_list="$node_list $node"

	if [ $index = 1 ]; then
		ppm_url=$node
	fi

	((index++))
done

scp $dir/nginx-local.sh $url:$dst
ssh $url sudo $dst/nginx-local.sh --server $server --env $env \
	--server-name $url $node_list

ssh $url rm -rf $dst

if [ -n "$jdk" ]; then
	jdk_opt="--jdk $jdk"
fi

$dir/deploy-nodes.sh --server $server --nodes $nodes --env $env $jdk_opt

dst=`ssh $ppm_url mktemp -d`
scp $dir/ppm-local.sh $ppm_url:$dst
ssh $ppm_url sudo $dst/ppm-local.sh
ssh $ppm_url rm -rf $dst

echo
