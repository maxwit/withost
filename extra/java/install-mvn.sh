#!/bin/sh

if [ $# = 1 ]; then
	DIR=~
	MVN=$1
elif [ $# = 3 ]; then
	# FIXME
	DIR=${2%%/}
	MVN=$3
else
	echo "usage: $0 [-d <InstallPath>] <Maven Package>!"
	exit 1
fi

MAVEN_HOME=`tar -tf $MVN | head -n 1`
MAVEN_HOME=${MAVEN_HOME%%/*}
echo "Installing $MAVEN_HOME ..."
MAVEN_HOME=$DIR/$MAVEN_HOME

if [ ! -x $MAVEN_HOME/bin/mvn ]; then
	tar xf $MVN -C $DIR || exit 1
fi

if [ -e /etc/redhat-release ]; then
	profile=$HOME/.bash_profile
else
	profile=$HOME/.profile
fi

sed -i '/MAVEN_HOME/d' $profile

cat >> $profile << EOF
export MAVEN_HOME=$MAVEN_HOME
export PATH=\$MAVEN_HOME/bin:\$PATH
EOF

source $profile
mvn -version || exit 1

echo "MVN successfully installed to $MAVEN_HOME"
