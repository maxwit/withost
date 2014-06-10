import os
import urllib
from lib import base

def install_pip():
	dest = '/tmp/get-pip.py'
	url = 'https://bootstrap.pypa.io/get-pip.py'
	if not os.path.exists(dest):
		print '%s -> %s:' % (url, dest)
		urllib.urlretrieve(url, dest, base.process)
		print

	print 'Installing pip'
	return os.system('python ' + dest)

def setup(dist, conf, apps):
	if 'python-pip' not in apps:
		install_pip()
	else:
		os.system('pip install -U pip')

	os.system('pip install django')
