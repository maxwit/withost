#!/bin/sh

env='local'
domain='2dupay.com'
nodes=1

enable_http=0
enable_ppm=0

cwd=`dirname $0`

while [ $# -gt 0 ]
do
	case $1 in
	-e|--env)
		env=$2
		shift
		;;
	-a|--app)
		app=$2
		shift
		;;
	-j|--jdk)
		jdk=$2
		shift
		;;
	-h|--enable-http)
		enable_http=1
		;;
	-p|--enable-ppm)
		enable_ppm=1
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

alias ssh='ssh -o StrictHostKeyChecking=no'

if [ ! -e pom.xml ]; then
	echo "pls run the program inside a maven project!"
	exit 1
fi

if grep dm-parent pom.xml > /dev/null; then
	plat=dm
elif grep sp-parent pom.xml > /dev/null; then
	plat=sp
else
	echo "project not supported!"
	exit 1
fi

if [ $plat = dm ]; then
	base=11
else
	base=21
fi

port=8080

for e in local devel testing staging production
do
	if [ $env = $e -a $env != testing -a $env != production ]; then
		port=${base}080
		break
	fi

	((base++))
done

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

if [ -z "$app" ]; then
	# FIXME
	for j in `ls */target/*.jar`
	do
		if [ -x $j ]; then
			app=$j
			break
		fi
	done

	if [ -z "$app" ]; then
		echo "no app found!"
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
		node_url="$plat$index.$domain"
	fi

	if [ $plat = dm -a $index = 1 ]; then
		# FIXME
		ppm_server=$node_url

		if [ $env != local -a $enable_http = 1 ]; then
			dst=`ssh $node_url mktemp -d`
			scp $cwd/nginx-local.sh $node_url:$dst
			ssh $node_url sudo bash $dst/nginx-local.sh --plat $plat --env $env \
				--server-name $node_url --port $port localhost
			ssh $node_url rm -rf $dst
		fi
	fi

	echo "[$index/$nodes] deploying $node_url ..."

	dst=`ssh $node_url mktemp -d`

	if [ -n "$jdk" ]; then
		scp $jdk $node_url:$dst
		scp $cwd/../witjee/jdk/install-jdk.sh $node_url:$dst
		ssh $node_url sudo bash $dst/install-jdk.sh $dst/`basename $jdk`
	fi

	scp $app $node_url:$dst
	scp $cwd/node-local.sh $node_url:$dst/
	ssh $node_url sudo bash $dst/node-local.sh --plat $plat --port $port --env $env --app $dst/`basename $app`

	ssh $node_url rm -rf $dst

	echo

	#tmp=`ssh $node_url /sbin/ifconfig | egrep -o "10\.[0-9]+\.[0-9]+\.[0-9]+" | head -1`
	tmp=`ssh $node_url /sbin/ifconfig | egrep -o "192\.168\.79\.13[0-9]" | head -1`
	if [ -z "$tmp" ]; then
		echo "fail to get Intranet IP!"
	else
		node_url=$tmp
		echo "Intranet IP = $node_url"
	fi

	node_list="$node_list $node_url"

	echo

	((index++))
done


	echo "$node_list"

# FIXME
if [ $enable_ppm = 1 -a $plat = dm ]; then
	dst=`ssh $ppm_server mktemp -d`
	scp $cwd/ppm-local.sh $ppm_server:$dst
	ssh $ppm_server sudo $dst/ppm-local.sh
	ssh $ppm_server rm -rf $dst
fi
if [ $enable_http = 1 ]; then
node_temp=1
	while [ $node_temp -le $nodes ]
	do
		if [ $env = local ]; then
			http_server="localhost"
		else
			http_server="$plat$node_temp.$domain"
		fi
	
		dst=`ssh $http_server mktemp -d`
		scp $cwd/nginx-local.sh $http_server:$dst
		ssh $http_server sudo bash $dst/nginx-local.sh --plat $plat --env \
			$env --server-name $plat.$domain --port $port $node_list
		ssh $http_server rm -rf $dst
		((node_temp++))
	done
fi
