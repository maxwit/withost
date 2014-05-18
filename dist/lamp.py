#!/usr/bin/python

import os, sys
import tarfile
import urllib

def process(a,b,c):
	per = 100 * a * b / c
	if per >= 100:
		per = 100

	print '[Downloading...\t\t\t\t%.2f%%]\r' % per,
	sys.stdout.flush();

def install_django(dver):
	dmaj = dver[:-2]

	fn = 'Django-%s.tar.gz' % dver
	filepath = '/tmp/' + fn
	url = 'https://www.djangoproject.com/m/releases/%s/%s' % (dmaj, fn)
	if not os.path.exists(filepath):
		print '%s -> %s:' % (url, filepath)
		urllib.urlretrieve(url, filepath, process)
		print

	if not os.path.exists(filepath[:-7]):
		tar = tarfile.open(filepath)
		print 'extracting '
		for name in tar.getnames():
			print '.',
			tar.extract(name,os.path.dirname(filepath))
		print

	print 'Installing %s' % fn[:-7]
	os.system('python %s/setup.py -q install' % filepath[:-7])
	# FIXME
	django = '/usr/bin/django-admin'
	os.rename(django + '.py', django)

def setup(conf, apps):
	if 'python-django' not in apps:
		# FIXME
		install_django('1.6.2')
