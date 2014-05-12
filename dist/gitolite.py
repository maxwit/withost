#!/usr/bin/python

import os

# FIXME
def setup(dist, apps):
	if dist.name in ['Ubuntu']:
		os.system("cp dist/gitolite/run /etc/service/git-daemon/")
		#os.system("killall git-daemon")
	else:
		os.system("cp dist/gitolite/git /etc/xinetd.d/")
		#os.system("systemctl restart xinetd")
