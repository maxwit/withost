#!/usr/bin/python

import os,re
import shutil
import tarfile
import tempfile
import platform
import sys,urllib

def process(a,b,c):

	per = 100 * a * b / c
	if per >= 100:
		per = 100

	print '[Downloading...\t\t\t\t%.2f%%]\r' % per,
	sys.stdout.flush();


def multiple_replace(text, sdict):
	rx = re.compile('|'.join(map(re.escape,sdict)))
	def one_xlat(match):
		return sdict[match.group(0)]
	return rx.sub(one_xlat,text)


def build_django():

	dver = "1.6.2"
	dmaj = dver[:-2] 

	prefix = "/tmp/"
	fn = "Django-" + dver + ".tar.gz"
	filepath = prefix + fn
	url = "https://www.djangoproject.com/m/releases/" + dmaj + "/" + fn
	if not os.path.exists(filepath):
		print "Downloading from %s ,please wait." % url 
		urllib.urlretrieve(url,filepath,process)

	if not os.path.exists(filepath[:-7]):
		tar = tarfile.open(filepath)
		for name in tar.getnames():
			print name 
			tar.extract(name,os.path.dirname(filepath))
	print "Install %s" %fn[:-7]
	os.system("python %s/setup.py install " %filepath[:-7])


def lamp_setup(site):

	docroot = "/var/www/" + site
	pattern = {"__DOCROOT__":docroot, "__SITENAME__":site}

	src = 'apache/site.conf'
	site_conf = '/tmp/exports'

	fsrc = open(src)
	fdst = open(site_conf,'w+')

	for line in fsrc:
		line = multiple_replace(line, pattern)
		fdst.write(line)

	fsrc.close()
	fdst.close()

	django_admin = os.popen('which django-admin.py').read().strip()
	if not django_admin:
		django_admin = os.popen('which django-admin').read().strip()

	distri = platform.linux_distribution()[0].lower() 
        if os.path.exists('/etc/httpd'):
		shutil.copyfile(site_conf, "/etc/httpd/conf.d/%s.conf" % site)
		if not django_admin :
			build_django()

	elif os.path.exists('/etc/apache2'):
		shutil.copyfile(site_conf, " /etc/apache2/sites-available/%s.conf" % site) 
		os.system("a2ensite %s.conf" % site)

	else:
		print 'Not Supported !'

	os.system(django_admin + " startproject mytest")
