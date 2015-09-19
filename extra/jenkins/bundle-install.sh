#!/bin/sh

cd `dirname $0`

function restart_jenkins
{
	# FIXME: restart in jenkins way
	which systemctl > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		sudo systemctl restart jenkins || exit 1
	else
		sudo service jenkins restart  || exit 1
	fi
}

if [ $UID -eq 0 ]; then
	echo "do NOT run as root!"
	exit 1
fi

sudo ./install-jenkins.sh 8580 || exit 1

sudo -H -u jenkins ./genkey.sh || echo "Warning: fail to generate ssh key!"
temp=`mktemp -d`
sudo chgrp jenkins $temp
chmod g+rwx $temp
src="/var/lib/jenkins/.ssh/id_rsa.pub"
dst="192.168.3.3:/mnt/witpub/devel/jenkins/authorized_keys"
echo "copying $src -> $dst"
sudo -u jenkins cp $src $temp && \
scp $temp/id_rsa.pub $dst || \
echo "Warning: fail to copy id_rsa.pub to file server!"
echo

sudo -u jenkins ./jenkins-plugin.sh
if [ $? -ne 0 ]; then
	restart_jenkins
	sudo truncate --size 0 /var/log/jenkins/jenkins.log
	sudo -u jenkins ./jenkins-plugin.sh || exit 1
fi

restart_jenkins
echo
