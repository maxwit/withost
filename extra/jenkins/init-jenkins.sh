#!/bin/sh

if [ $USER != 'jenkins' ]; then
	echo "must run as jenkins!"
	exit 1
fi

# FIXME on redhat
cd
pwd
rm -rf .ssh || exit 1
ssh-keygen -P '' -f .ssh/id_rsa || exit 1
exit 0

for plugin in git gitlab-plugin python perl
do
	echo "Installing plugin '$plugin' ..."
	for ((i=0; i<5; i++))
	do
		sudo -u jenkins java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:$port/ install-plugin $plugin
		if [ $? -eq 0 ]; then
			break;
		fi

		sleep 1
		echo "try again ..."
	done
done
