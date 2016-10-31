#!/bin/bash

project=sp
group="cn.inspiry.$project"
version="1.2.3-SNAPSHOT"

while [ $# -gt 0 ]
do
	case $1 in
		-p|--project)
			project=$2
			shift
			;;
		*)
			echo "Invalid option '$1'"
			exit 1
			;;
	esac

	shift
done

for module in base-iface base-service back-web back-openapi
do
	name=(${module//-/ })

	cate=${name[0]}
	smod=${name[1]}

	case $cate in
		back)
			dep="web,websocket"
			if [ $smod == 'openapi' ]; then
				dep="$dep,security,jdbc,mysql"
			fi
			;;
		base)
			if [ $smod == 'service' ]; then
				dep="mysql,mybatis"
			fi
			;;
		*)
			;;
	esac

	art="$project-$module"

	if [ ! -z "$dep" ]; then
		dep="-d=$dep"
	fi

	if [ $smod == iface ]; then
		mvn archetype:generate -DartifactId=$art -DgroupId=$group.$smod -DpackageName=$group.$smod -Dversion=$version \
			-DarchetypeCatalog=local -DinteractiveMode=false || exit 1
		sed -i -e 's/3\.8\.1/4.12/' \
			-e "s/<groupId>.*</<groupId>$group</" \
			$art/pom.xml

		temp=`mktemp`
		cat > $temp << _EOF_
		<dependency>
			<groupId>$group</groupId>
			<artifactId>$art</artifactId>
			<version>$version</version> <!-- FIXME: to be removed -->
		</dependency>

_EOF_
	else
		spring init -a=$art -g=$group --package-name=$group.$smod -v=$version $dep $art
	fi

	#if [ $cate = web ]; then
	#	touch $art/src/main/resources/static/index.js
	#	touch $art/src/main/resources/templates/index.ftl
	#fi

	cd $art || continue
	git init
	#git remote add origin git@git.debug.live:inspiry-platform/$art.git
	git remote add origin git@git.debug.live:maxwit-demo/$art.git
	git add .
	git commit -asm "init"
	git push -u origin master
	cd -

	echo
done

rm -f $temp
