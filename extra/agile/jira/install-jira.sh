#!/bin/sh

# user
# port
# chkconfig
# different versions (i.e 6.x) support
# crack
# cat
# JIRA_HOME?
# source jdk

JIRA_HOME=/var/lib/jira 
JIRA_PARENT=/opt

if [ $UID -ne 0 ]; then
	echo "pls run as root!"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "usage: $0 <path/to/jira/tarball>"
	exit 1
fi

TARBALL=$1

if [ ! -e $TARBALL ]; then
	echo "'$TARBALL' does NOT exist!"
	exit 1
fi

JIRA_APP=`basename $TARBALL`
JIRA_APP=${JIRA_APP%.tar.gz}
JIRA_BASE=$JIRA_PARENT/$JIRA_APP-standalone

JIRA_MAJOR=`echo $JIRA_APP | sed "s/.*-\([0-9]\+\)\..*/\1/g"`
if [ $JIRA_MAJOR -le 6 ]; then
	JAVA_MAJOR=7
else
	JAVA_MAJOR=8
fi

if [ -e /etc/redhat-release ]; then
	yum install -y java-1.${JAVA_MAJOR}.0-openjdk-devel
else
	apt-get install -y openjdk-${JAVA_MAJOR}-jdk
fi

useradd -m -d $JIRA_HOME jira

echo -n "Installing JIRA ."
count=0
tar xvf $TARBALL -C $JIRA_PARENT | while read line
do
	((count++))
	if [ $((count % 200)) -eq 0 ]; then
		 echo -n .
	fi
done || exit 1
echo " Done."

if [ ! -d $JIRA_BASE ]; then
	# BUG
	echo "'$JIRA_BASE' not found!"
	exit 1
fi

sed -i -e 's/\([pP]ort\)="8/\1="9/g' $JIRA_BASE/conf/server.xml
sed -i 's/JIRA_USER=".*/JIRA_USER="jira"/' $JIRA_BASE/bin/user.sh
chown jira.jira -R $JIRA_BASE

cat > /etc/init.d/jira << EOF
#!/bin/sh

# chkconfig: - 85 15 
# description: Jira Issue Track System

# for 7.x
# source /etc/profile.d/jdk.sh

export JIRA_HOME=$JIRA_HOME

case \$1 in
start)
	$JIRA_BASE/bin/start-jira.sh
	;;
stop)
	$JIRA_BASE/bin/stop-jira.sh
	;;
restart)
	$JIRA_BASE/bin/stop-jira.sh
	$JIRA_BASE/bin/start-jira.sh
	;;
esac
EOF

chmod +x /etc/init.d/jira

if [ -e /etc/redhat-release ]; then
	chkconfig jira on
fi

service jira start

echo
