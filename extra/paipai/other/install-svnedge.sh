#!/bin/bash
sudo ufw disable

sudo tar xf jdk-1.8.tar -C /usr/local
sudo tar xf svnedge-5.1.4.tar.gz -C /usr/local

sudo ln -s /usr/local/jdk1.8.0_101 /usr/local/jdk


groupadd svn
useradd -g svn -M svnroot
usermod -a -G sudo svnroot

python --version
if [  $? -ne 0 ]; then
	echo "python not install"
	exit 1
fi 

cat >> /etc/profile << EOF
	export JAVA_HOME=/usr/local/jdk
	export JRE_HOME=/usr/local/jdk/jre
	export PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin
EOF
source /etc/profile
java -version
if [  $? -ne 0 ]; then
	echo "jdk not install"
	exit 1
fi 

chmod 777 /etc/sudoers
echo "svnroot ALL=NOPASSWD:ALL" >> /etc/sudoers
sed -i "s/^%admin ALL=(ALL) ALL/#%admin ALL=(ALL) ALL/"
chmod 0440 /etc/sudoers

chown -R svnroot:svn /usr/local/csvn/*

sudo su - svnroot -c "source /etc/profile"
sudo su - svnroot -c "java -version"
sudo su - svnroot -c "sudo /usr/local/csvn/bin/csvn-httpd install"
sudo su - svnroot -c "sudo /usr/local/csvn/bin/csvn install"
sudo su - svnroot -c "sed -i \"s/#RUN_AS_USER=/RUN_AS_USER=svnroot/\" /usr/local/csvn/data/conf/csvn.conf"
sudo su - svnroot -c "sed -i \"s/#JAVA_HOME=/JAVA_HOME=\/usr\/local\/jdk/\" /usr/local/csvn/data/conf/csvn.conf"
sudo su - svnroot -c "/usr/local/csvn/bin/csvn start"

