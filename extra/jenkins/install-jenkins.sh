#!/bin/sh

if [ $UID -ne 0 ]; then
	echo "must run as root!"
	exit 1
fi

if [ $# -eq 1 ]; then
	port=$1
else
	port=8080
fi

if [ ! -e /etc/init.d/jenkins ]; then
	if [ -e /etc/redhat-release ]; then
		if [ ! -e /etc/yum.repos.d/jenkins.repo ]; then
			wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
			rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
		fi

		for ((i=0; i<5; i++))
		do
			yum install -y jenkins java-1.7.0-openjdk-devel
			err=$?
			[ $err -eq 0 ] && break
		done
		[ $err -ne 0 ] && exit 1

		[ $port -ne 8080 ] && sed -i "s/^JENKINS_PORT=.*/JENKINS_PORT=\"$port\"/" /etc/sysconfig/jenkins || exit 1

		usermod -a -G root jenkins
		chmod g+r /etc/shadow

		which firewall-cmd
		if [ $? -eq 0 ]; then
			firewall-cmd --zone=public --add-port=$port/tcp --permanent
			firewall-cmd --zone=public --add-service=http --permanent
			firewall-cmd --reload
		else
			iptables -I INPUT -p tcp --dport $port -j ACCEPT
			iptables-save
			# service iptables restart
		fi
	else
		if [ ! -e /etc/apt/sources.list.d/jenkins.list ]; then
			wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
			echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
			apt-get update
		fi

		for ((i=0; i<5; i++))
		do
			apt-get install -y jenkins openjdk-7-jdk || exit 1
			err=$?
			[ $err -eq 0 ] && break
		done
		[ $err -ne 0 ] && exit 1

		[ $port -ne 8080 ] && sed -i "s/^HTTP_PORT=.*/HTTP_PORT=\"$port\"/" /etc/default/jenkins || exit 1

		usermod -a -G shadow jenkins
	fi
fi
echo

which systemctl > /dev/null 2>&1
if [ $? -eq 0 ]; then
	systemctl enable jenkins || exit 1
	systemctl start jenkins || exit 1
else
	which chkconfig > /dev/null 2>&1 && chkconfig jenkins on || exit 1
	service jenkins start  || exit 1
fi

echo "Jenkins installed successfully, port=$port."
echo
