#! /bin/sh

JIRA_HOME=/var/lib/jira 
mkdir -vp $JIRA_HOME
export JIRA_HOME=$JIRA_HOME

INSTALL_PATH=/opt/atlassian-jira-software-7.0.2-standalone

rm -rf $INSTALL_PATH
cd  `dirname $INSTALL_PATH`

tar xf /mnt/witpub/devel/pm/atlassian-jira-software-7.0.2-jira-7.0.2.tar.gz || exit 1

cat > /etc/init.d/jira << EOF
case $1 in
start)
	$INSTALL_PATH/bin/start-jira.sh
	;;
stop)
	$INSTALL_PATH/bin/stop-jira.sh
	;;
esac
EOF

if [ -e /etc/redhat-release ]; then
	chkconfig jira on
fi
