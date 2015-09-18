import os
import urllib
from lib import base

def setup(dist, apps, conf):
	if 'python-pip' not in apps:
		dest = '/tmp/get-pip.py'
		url = 'https://bootstrap.pypa.io/get-pip.py'
		if not os.path.exists(dest):
			print '%s -> %s:' % (url, dest)
			urllib.urlretrieve(url, dest, base.process)
			print
		print 'Installing pip'
		os.system('python ' + dest)
	else:
		os.system('pip install -U pip')

	os.system('pip install django')
