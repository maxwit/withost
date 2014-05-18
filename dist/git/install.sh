#!/bin/bash

#if [ ! -e .ssh ]; then
#	echo | ssh-keygen -N ''
#fi

git_path="/tmp/gitolite"

if [ ! -d $git_path ]; then
	#git clone git://github.com/sitaramc/gitolite.git $git_path
	git clone git://192.168.1.1/project/gitolite.git $git_path
fi

mkdir -p ${HOME}/bin
$git_path/install -to ${HOME}/bin

#gitolite setup

## TODO: fix by patch
#grep "UMASK.*=" ~/.gitolite.rc
#sed -i 's/\(UMASK.*\)=>\(\s\+\)\([0-7]\+\)/\1=>\20027/' ~/.gitolite.rc
#grep "UMASK.*=" ~/.gitolite.rc
