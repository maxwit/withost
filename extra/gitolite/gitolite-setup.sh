#!/bin/bash

gitolite_setup()
{
	if [ ! -d $HOME/.ssh ]; then
		echo | ssh-keygen -N ''
	fi

	if grep -w ^git /etc/group > /dev/null; then
		sudo useradd -g git -s /bin/bash -m git
	else
		sudo useradd -s /bin/bash -m git
	fi

	gl=(`groups`)
	gl[0]='git'
	sudo usermod -G ${gl// /,} $USER

	tmpd=`mktemp -d`
	chmod 755 $tmpd

	key=`awk '{print $3}' ~/.ssh/id_rsa.pub | tr 'A-Z@' 'a-z-'`
	cp -f $HOME/.ssh/id_rsa.pub $tmpd/${key}.pub

	echo "gitolite setup with ${key}.pub:"
	sudo -H -i -u git gitolite setup -pk $tmpd/${key}.pub

	git clone git@127.0.0.1:gitolite-admin $HOME/gitolite-admin
	cd $HOME/gitolite-admin
	sed -i "1i @$USER = $key\n" conf/gitolite.conf
	sed -i "s/\(=\s\+\)$key/\1@$USER/" conf/gitolite.conf
	git commit -asm "update gitolite.conf"
	git push
	cd -
	echo

	mkdir -p $HOME/bin
	cp -v key-update.py $HOME/bin
	cp -v repo-admin.py $HOME/bin
}

gitolite_remove()
{
	rm -rf $HOME/gitolite-admin
	echo

	echo "deleting user git"
	sudo userdel -r -f git
}

if [ $# == 0 ]; then
	gitolite_setup
else
	gitolite_remove
fi
