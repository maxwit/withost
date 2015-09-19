#!/bin/sh

if [ $USER != 'jenkins' ]; then
	echo "must run as jenkins!"
	exit 1
fi

cd /var/lib/jenkins

if [ ! -e .ssh/id_rsa ]; then
	if [ ! -d .ssh ]; then
		mkdir .ssh
		chmod 700 .ssh
	fi
	ssh-keygen -P '' -f .ssh/id_rsa || exit 1
fi

pid=`jps | awk '$2 == "jenkins.war" {print $1}'`
if [ -z "$pid" ]; then
	echo "jenkins is not running!"
	exit 1
fi

if [ -e /etc/redhat-release ]; then
	jenkins_conf=/etc/sysconfig/jenkins
else
	jenkins_conf=/etc/default/jenkins
fi

port=`awk -F '=' '$1 == "HTTP_PORT" {print $2}' $jenkins_conf`
if [ -z "$port" ]; then
	echo "invalid '$jenkins_conf'!"
	exit 1
fi

for plugin in git gitlab-plugin python perl
do
	echo "Installing plugin '$plugin' ..."
	for ((i=0; i<5; i++))
	do
		java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:$port/ install-plugin $plugin
		if [ $? -eq 0 ]; then
			break;
		fi

		sleep 1
		echo "try again ..."
	done
done
