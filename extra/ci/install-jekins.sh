#!/bin/sh

if [ $UID -ne 0 ]; then
	echo -e "must run as root!"
	exit 1
fi

if [ -e /etc/redhat-release ]; then
	wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
	rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
	yum install -y jenkins

	usermod -a -G root jenkins
	chmod g+r /etc/shadow
else
	wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
	echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
	apt-get update
	apt-get install -y jenkins

	usermod -a -G shadow jenkins
fi

for plugin in gitlab-plugin
do
	sudo -i -u jenkins java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ install-plugin $plugin -restart
done

JENKINS_HOME=/var/lib/jenkins
tmpf=`mktemp -u`
sudo -i -u $SUDO_USER tar cf $tmpf .ssh
sudo -u jenkins rm -rf ${JENKINS_HOME}/.ssh
sudo -u jenkins tar xf $tmpf -C ${JENKINS_HOME}/
sudo -u jenkins rm -f ${JENKINS_HOME}/.ssh/known_hosts ${JENKINS_HOME}/.ssh/authorized_keys
#sudo -u jenkins ls -al ${JENKINS_HOME}/.ssh
rm $tmpf

##if [ ! -e ~/.ssh/id_rsa ]; then
##	sudo -u jenkins ssh-keygen -P '' -f ~/.ssh/id_rsa
##fi
##
##sudo -u jenkins cp -v ~/.ssh/id_rsa.pub /tmp/jenkins_id_rsa.pub
