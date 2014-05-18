#!/usr/bin/python

import os

# FIXME
def setup(conf, apps):
	if os.path.exists('/etc/service/git-daemon/'):
		os.system("cp dist/git/run /etc/service/git-daemon/")
		os.system("killall git-daemon")
	elif os.path.exists('/etc/xinetd.d/'):
		os.system("cp dist/git/git /etc/xinetd.d/")
		os.system("systemctl restart xinetd")
	else:
		print 'System not supported!'
