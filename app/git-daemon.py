#!/usr/bin/python

import os
import shutil

# FIXME
def setup(dist, apps):
	if os.path.exists('/etc/service/git-daemon/'):
		shutil.copyfile(app/git/run', '/etc/service/git-daemon/run')
		os.chmod('/etc/service/git-daemon/run', 0755)
		#os.system("killall git-daemon")
	elif os.path.exists('/etc/xinetd.d/'):
		shutil.copyfile(app/git/git', '/etc/xinetd.d/git')
		#os.system("systemctl restart xinetd")
	else:
		print 'System not supported!'
