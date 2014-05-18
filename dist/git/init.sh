#!/bin/bash

if [ ! -d $HOME/.ssh ]; then
	echo | ssh-keygen -N ''
fi

cp -v $HOME/.ssh/id_rsa.pub $1
