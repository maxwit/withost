#! /bin/sh

# user
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

tar xf /mnt/witpub/devel/pm/jira/atlassian-jira-software-7.0.2-jira-7.0.2.tar.gz || exit 1
sed -i 's/JIRA_USER=".*/JIRA_USER="jira"/' $INSTALL_PATH/bin/user.sh
chown jira.jira -R $INSTALL_PATH

cat > /etc/init.d/jira << EOF
#!/bin/sh

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
