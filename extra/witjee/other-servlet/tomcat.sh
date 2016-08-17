#!/bin/sh

#cd `dirname $0`
top=$PWD

tomcat="apache-tomcat-8.0.9"

temp=`mktemp -d`

tar xvf /mnt/witpub/devel/source/jee/$tomcat.tar.gz -C $temp

cd $temp/$tomcat

i=0
to=3

while [ $i -lt $to ]
do
	ant && break
done

cp $top/validate.jsp webapps || \
{
	rm -rf $temp
	exit 1
}


bin/startup.sh || \
{
	echo "fail to start tomcat!"
	rm -rf $temp
	exit 1
}

curl -O $temp/validate.jsp http://127.0.0.1:8080/validate.jsp

diff $temp/validate.jsp $top/validate.jsp || \
{
	echo "fail to access the index page!"
}

rm -rf $temp
