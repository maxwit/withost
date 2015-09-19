#!/bin/sh

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

port=8580

sudo ./install-jenkins.sh $port || exit 1

temp=`mktemp -d`
sudo chgrp jenkins $temp
chmod g+rwx $temp

cp init-jenkins.sh $temp && \
sudo -u jenkins $temp/init-jenkins.sh
if [ $? -ne 0 ]; then
	restart_jenkins
	sudo -u jenkins $temp/init-jenkins.sh || exit 1
fi

src="/var/lib/jenkins/.ssh/id_rsa.pub"
dst="192.168.3.3:/mnt/witpub/devel/jenkins/authorized_keys"
echo "copy $src -> $dst"
sudo -u jenkins cp -v $src $temp && \
scp $temp/id_rsa.pub $dst || \
echo "Warning: fail to copy id_rsa.pub to file server!"

restart_jenkins
