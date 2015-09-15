#!/bin/sh

if [ $# != 1 ]; then
	echo "usage: $0 <eclipse tarball>"
	echo
	exit 1
fi

dir=`dirname $0`
eclipse=$1
bn=`basename $1`
version=(${bn//-/ })

if [ ${version[0]} != 'eclipse' -o ${#version} -lt 3 ]; then
	echo "Invalid eclipse tarball name: $bn!"
	exit 1
fi

ename="eclipse-${version[2]}-${version[1]}"
epath=$HOME/$ename
temp=`mktemp -d`
tar xvf $eclipse -C $temp
rm -rf $epath
mv $temp/eclipse $epath

if [ -x "$epath/eclipse" -a -f "$epath/icon.xpm" ]; then
	desktop="${ename}.desktop"
	if [ ${version[1]} = 'cpp' ]; then
		dname=`echo "${version[2]} C/C++" | tr a-z A-Z`
	else
		dname=`echo "${version[2]} ${version[1]}" | tr a-z A-Z`
	fi
	cp -v $dir/eclipse.desktop ~/Desktop/$desktop
	sed -i -e "s:_NAME_:$dname:" -e "s:_EPATH_:$epath:" ~/Desktop/$desktop
	chmod +x ~/Desktop/$desktop
else
	echo "Invalid eclipse, pls check '$epath'!"
fi

echo
