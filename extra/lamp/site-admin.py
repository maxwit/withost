#!/usr/bin/python

import os,re
import shutil
import fileinput
import ConfigParser
from pwd import getpwnam
from grp import getgrnam
from optparse import OptionParser
from argparse import ArgumentParser

def multiple_replace(text, sdict):
	rx = re.compile('|'.join(map(re.escape,sdict)))
	def one_xlat(match):
		return sdict[match.group(0)]
	return rx.sub(one_xlat,text)

def get_path(sitename):
	if os.path.exists('/etc/httpd'):
		conf_path = '/etc/httpd/conf/httpd.conf'
		site_path = '/etc/httpd/conf.d/%s.conf' % sitename
		cmd = ""
	elif os.path.exists('/etc/apache2'):
		conf_path = '/etc/apache2/apache2.conf'
		site_path = "/etc/apache2/sites-available/%s.conf" % sitename
		cmd = '%s.conf' % sitename
	else:
		print 'Not Supported !'
		exit()

	if os.popen('which django-admin.py 2>/dev/null').read().strip():
		dcmd = 'django-admin.py'
	elif os.popen('which django-admin 2>/dev/null').read().strip():
		dcmd = 'django-admin'
	else:
		print 'please install django first!'
		exit()

	return  conf_path, site_path, dcmd, cmd

def add_site(servername, sitename,owner):
	(conf_path, site_path, dcmd, cmd) = get_path(sitename)

	docroot = "/var/www/" + sitename
	if wsgipath_exists(docroot, conf_path):
		print "The site %s is already exists! please check it!" % sitename
		return
	add_wsgipath(docroot, conf_path)

	pattern = {"__DOCROOT__":docroot, "__SITENAME__":sitename, "__SERVERNAME__":servername}

	src = 'apache/site.conf'
	site_conf = '/tmp/site.conf'

	fsrc = open(src)
	fdst = open(site_conf,'w+')

	for line in fsrc:
		line = multiple_replace(line, pattern)
		fdst.write(line)

	fsrc.close()
	fdst.close()

	shutil.copyfile(site_conf, site_path)
	shutil.copyfile(site_conf, site_path)
	if cmd:
		os.system("a2ensite " + cmd)

	pwd = os.getcwd()
	os.chdir('/var/www')
	os.system("%s startproject %s" % (dcmd, sitename))
	os.chown(docroot, getpwnam(owner).pw_uid, getgrnam(owner).gr_gid)
	os.chdir(pwd)

def del_site(sitename):
	(conf_path, site_path,dcmd, cmd) = get_path(sitename)

	docroot = "/var/www/" + sitename
	if not wsgipath_exists(docroot, conf_path):
		print "The site %s is not exits! please check it!" % sitename
		return
	del_wsgipath(docroot, conf_path)

	os.remove(site_path)
	if cmd:
		os.system("a2dissite " + cmd )

	shutil.rmtree(docroot)


def wsgipath_exists(docroot, conf_path):
	fd = open(conf_path)
	for line in fd:
		if line.__contains__(docroot):
			fd.close()
			return True
	fd.close()
	return False

def add_wsgipath(docroot, conf_path):
	wsgi_exists = False

	for line in fileinput.input(conf_path, inplace = 1):
		ln = line.split()

		if not ln:
			print line,
			continue

		if ln[0].strip() == "WSGIPythonPath":
			print "%s:%s\n" % (line[:-1],docroot),
			wsgi_exists = True
			continue

		if ln[0].strip() == "IncludeOptional" and not wsgi_exists:
			print "%s %s\n%s" % ("WSGIPythonPath", docroot, line),
			wsgi_exists = True
			continue

		print line,

	fileinput.close()

def del_wsgipath(docroot, conf_path):
	for line in fileinput.input(conf_path, inplace = 1):
		ln = line.split()

		if not ln:
			print line,
			continue

		if ln[0].strip() == "WSGIPythonPath":
			path_set = ln[1].split(':')
			if len(path_set) == 1 and path_set[0] == docroot:
				continue

			path_set.remove(docroot)
			line = ":".join(path_set)

			print "WSGIPythonPath %s\n" % line,
			continue
		print line,

	fileinput.close()

def remove(dist, conf, apps):

	if key in conf:
		for servername in conf[key].split():
			del_site(servername)

if __name__ == "__main__":
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = ArgumentParser(description='Add site or delete site')
	opt_parser.add_argument('operation', action='store',
						choices=('add','delete'),help='add or delete a site')
	opt_parser.add_argument('-s', '--servername', action='store',
						dest='servername', help='this is your servername')
	opt_parser.add_argument('-o', '--owner', action='store',
						dest='owner', help='the site owner')
	opt_parser.add_argument('sitename', action='store',
							help='this is your sitename')
	args = opt_parser.parse_args()

	if args.operation == 'add':
		if args.owner:
			add_site(args.servername, args.sitename, args.owner)
		else:
			add_site(args.servername, args.sitename, os.getlogin())
	else:
		del_site(args.sitename)
