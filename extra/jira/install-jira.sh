#! /bin/sh

JIRA_HOME=/var/lib/jira 
mkdir -vp $JIRA_HOME
export JIRA_HOME=$JIRA_HOME

cd /opt

rm -rf atlassian-jira-software-7.0.2-standalone
tar xf /mnt/witpub/devel/source/atlassian-jira-software-7.0.2-jira-7.0.2.tar.gz || exit 1

cd atlassian-jira-software-7.0.2-standalone
./bin/start-jira.sh
