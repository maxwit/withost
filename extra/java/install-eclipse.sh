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

count=0
tar xvf $eclipse -C $temp | while read x
do
	((count++))
	if [ $count -gt 900 ]; then
		echo -n -e "extracting $bn ... $(((count-600)/30))%\r"
	fi
done
#echo -n -e "extracting $bn ... 100%"
echo

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
