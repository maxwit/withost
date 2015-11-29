#! /bin/sh

# user
# port
# chkconfig
# different versions (i.e 6.x) support
# crack
# cat
# JIRA_HOME?
# source jdk

JIRA_HOME=/var/lib/jira 

if [ $UID -ne 0 ]; then
	echo "pls run as root!"
	exit 1
fi

useradd -m -d $JIRA_HOME jira

# FIXME
INSTALL_PATH=/opt/atlassian-jira-software-7.0.2-standalone

rm -rf $INSTALL_PATH
cd  `dirname $INSTALL_PATH`

echo -n "Installing JIRA ."
count=0
tar xvf /mnt/witpub/devel/jira/atlassian-jira-software-7.0.2-jira-7.0.2.tar.gz | while read line
do
	((count++))
	if [ $((count % 200)) -eq 0 ]; then
		 echo -n .
	fi
done || exit 1
echo " Done."

sed -i -e 's/\([pP]ort\)="8/\1="9/g' $INSTALL_PATH/conf/server.xml
sed -i 's/JIRA_USER=".*/JIRA_USER="jira"/' $INSTALL_PATH/bin/user.sh
chown jira.jira -R $INSTALL_PATH

cat > /etc/init.d/jira << EOF
#!/bin/sh

# chkconfig: - 85 15 

source /etc/profile.d/jdk.sh

export JIRA_HOME=$JIRA_HOME

case \$1 in
start)
	$INSTALL_PATH/bin/start-jira.sh
	;;
stop)
	$INSTALL_PATH/bin/stop-jira.sh
	;;
restart)
	$INSTALL_PATH/bin/stop-jira.sh
	$INSTALL_PATH/bin/start-jira.sh
	;;
esac
EOF

chmod +x /etc/init.d/jira

if [ -e /etc/redhat-release ]; then
	chkconfig jira on
fi

echo
