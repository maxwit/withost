#!/bin/sh

env='local'
nodes=1
domain='2dupay.com'

cwd=`dirname $0`

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
		echo "Usage: $0 [options]"
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
	;;
production)
	;;
devel|testing|staging)
	domain="$env.$domain"
	;;
*)
	echo "invalid environment '$env'!"
	exit 1
esac

if [ -z "$jar" ]; then
	# FIXME
	for j in `ls */target/*.jar`
	do
		if [ -x $j ]; then
			jar=$j
			break
		fi
	done

	if [ -z "$jar" ]; then
		echo "no jar found!"
		exit 1
	fi
fi

node_list=""
index=1

while [ $index -le $nodes ]
do
	if [ $env = local ]; then
		node_url="localhost"
	else
		node_url="$server$index.$domain"
	fi

	# FIXME
	if [ $server = dm -a $index = 1 ]; then
		ppm_server=$node_url
	fi

	echo "deploying $node_url ..."

	dst=`ssh $node_url mktemp -d`

	if [ -n "$jdk" ]; then
		scp $jdk $node_url:$dst
		scp $cwd/../witjee/jdk/install-jdk.sh $node_url:$dst
		ssh $node_url sudo $dst/install-jdk.sh $dst/`basename $jdk`
	fi

	scp $jar $node_url:$dst
	scp $cwd/node-local.sh $node_url:$dst/
	ssh $node_url sudo $dst/node-local.sh --server $server --env $env --jar $dst/`basename $jar`

	ssh $node_url rm -rf $dst

	echo

	#if [ $env = production ]; then
	#	dst_tmp=`ssh $node_url mktemp -d`
	#	scp $cwd/get-ip.sh $node_url:$dst_tmp
	#	node_url=`ssh $node_url $dst_tmp/get-ip.sh`
	#	ssh $node_url rm -rf $dst_tmp
	#	echo "Intranet IP = $node_url"
	#fi

	node_list="$node_list $node_url"

	echo

	((index++))
done

# FIXME
if [ $server = dm ]; then
	dst=`ssh $ppm_server mktemp -d`
	scp $cwd/ppm-local.sh $ppm_server:$dst
	ssh $ppm_server sudo $dst/ppm-local.sh
	ssh $ppm_server rm -rf $dst
fi

if [ $env = local ]; then
	http_server="localhost"
else
	http_server="$server.$domain"
fi

dst=`ssh $http_server mktemp -d`
scp $cwd/nginx-local.sh $http_server:$dst
ssh $http_server sudo $dst/nginx-local.sh --server $server --env $env \
	--server-name $http_server $node_list
ssh $http_server rm -rf $dst

echo
