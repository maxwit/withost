#! /bin/sh

# user
# port
# chkconfig
# different versions (i.e 6.x) support
# crack
# cat
# JIRA_HOME?
# source jdk

JIRA_APP=atlassian-jira-6.3.6
#JIRA_APP=atlassian-jira-software-7.0.2

JIRA_HOME=/var/lib/jira 
JIRA_PARENT=/opt
JIRA_BASE=$JIRA_PARENT/$JIRA_APP-standalone

if [ $UID -ne 0 ]; then
	echo "pls run as root!"
	exit 1
fi

useradd -m -d $JIRA_HOME jira

echo -n "Installing JIRA ."
count=0
tar xvf /mnt/witpub/devel/jira/$JIRA_APP.tar.gz -C $JIRA_PARENT | while read line
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

source /etc/profile.d/jdk.sh

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

echo
