#!/bin/sh

if [ $# -ne 2 ]; then
	echo "usage: $0 <property dir> <tomcat home>"
	exit 1
fi

src=$1
dst=${2%/}

if [ ! -d $src ]; then
	echo "directory '$src' not exists!"
	exit 1
else
	ls $src/*.properties > /dev/null 2>&1 || {
		echo "invalid property directory: '$src'!"
		exit 1
	}
fi

if [ ! -x $dst/bin/catalina.sh ]; then
	echo "invalid tomcat home: '$dst'!"
	exit 1
fi

env="$dst/env"

sudo -u tomcat rm -rf $env
sudo -u tomcat cp -r $src $env

temp=`mktemp`
chmod a+r $temp
cat > $temp << EOF
JAVA_OPTS="\$JAVA_OPTS -Dglobal.config.path=$env"
EOF

sudo -u tomcat cp $temp $dst/bin/setenv.sh

rm $temp
