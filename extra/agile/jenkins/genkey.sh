#!/bin/sh

cd

if [ ! -e .ssh/id_rsa ]; then
	if [ ! -d .ssh ]; then
		mkdir .ssh
		chmod 700 .ssh
	fi
	ssh-keygen -P '' -f .ssh/id_rsa || exit 1
else
	echo "$PWD/.ssh/id_rsa exists (skipped)."
fi

echo
