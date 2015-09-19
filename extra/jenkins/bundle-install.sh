#!/bin/sh

if [ $UID -eq 0 ]; then
	echo "do NOT run as root!"
	exit 1
fi

port=8580

sudo ./install-jenkins.sh $port

# FIXME
for ((i=5;i>0;i--))
do
	echo $i
	sleep 1
done

temp=`mktemp -d`
sudo chgrp jenkins $temp
chmod g+rwx $temp

cp init-jenkins.sh $temp
sudo -u jenkins $temp/init-jenkins.sh

JENKINS_HOME=/var/lib/jenkins
sudo -u jenkins -cp -v $JENKINS_HOME/.ssh/id_rsa.pub $temp
scp $temp/id_rsa.pub 192.168.3.3:/mnt/witpub/devel/jenkins/authorized_keys || \
echo "Warning: fail to copy id_rsa.pub to file server!"

# FIXME: restart in jenkins way
which systemctl > /dev/null 2>&1
if [ $? -eq 0 ]; then
	sudo systemctl restart jenkins || exit 1
else
	sudo service jenkins restart  || exit 1
fi
