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

rm -rf $env
cp -rv $src $env

cat > $dst/bin/setenv.sh << EOF
JAVA_OPTS="\$JAVA_OPTS -Xms1024m -Xmx1024m -XX:MaxNewSize=512m -XX:MaxPermSize=512m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"
JAVA_OPTS="\$JAVA_OPTS -Dglobal.config.path=$env"
EOF

echo
