#!/usr/bin/python

import os, re
import shutil
from argparse import ArgumentParser

# FIXME
http_root = '/var/www/'
# or (for Ngnix):
# http_root = '/usr/share/nginx/'
a2_site = False

def multiple_replace(text, sdict):
	rx = re.compile('|'.join(map(re.escape, sdict)))
	def one_xlat(match):
		return sdict[match.group(0)]
	return rx.sub(one_xlat, text)

def get_path(server_name):
	site_name = server_name.replace('.', '_')

	if os.path.exists('/etc/httpd'):
		#http_conf = '/etc/httpd/conf/httpd.conf'
		site_conf = '/etc/httpd/conf.d/%s.conf' % site_name
	elif os.path.exists('/etc/apache2'):
		#http_conf = '/etc/apache2/apache2.conf'
		site_conf = '/etc/apache2/sites-available/%s.conf' % site_name
		a2_site = True
	else:
		print 'Not Supported !'
		exit()

	#site_root = http_root + server_name
	site_root = http_root + site_name

	return (site_conf, site_root)

def add_site(server_name, owner):
	print 'creating %s for %s ...' % (server_name, owner)

	(site_conf, site_root) = get_path(server_name)

	if os.path.exists(site_root):
		print 'The site "%s" already exists! (skipped)' % server_name
		return

	#main_dir = server_name.split('.')[0]
	main_dir = 'main'

	pwd = os.getcwd()
	os.chdir(http_root)
	os.system('django-admin.py startproject ' + main_dir)
	os.rename(main_dir, os.path.basename(site_root))
	os.chdir(pwd)

	# FIXME
	group = 'apache'
	os.system('chown %s.%s -R %s' % (owner, group, site_root))
	os.system('chmod g+w -R ' + site_root)

	pattern = {'__DOCROOT__':site_root, '__MAINDIR__':main_dir, '__SERVERNAME__':server_name}

	fsrc = open('dist/site/apache.conf')
	fdst = open(site_conf, 'w+')

	# FIXME
	fdst.write('WSGIPythonPath %s\n\n' % site_root)

	for line in fsrc:
		line = multiple_replace(line, pattern)
		fdst.write(line)

	fsrc.close()
	fdst.close()

	if a2_site:
		os.system('a2ensite ' + os.path.basename(site_conf))

def del_site(server_name):
	print 'removing %s ...' % server_name

	(site_conf, site_root) = get_path(server_name)

	if not os.path.exists(site_root):
		print 'The site "%s" does not exist!' % server_name
		return

	if a2_site:
		os.system('a2dissite ' + os.path.basename(site_conf))
	os.remove(site_conf)

	shutil.rmtree(site_root)

def setup(dist, conf, apps):
	os.system('pip install MySQL-python')

	for server_name in conf['web.site'].split():
		add_site(server_name, os.getlogin())
		print

def remove(dist, conf, apps):
	for server_name in conf['web.site'].split():
		del_site(server_name)

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = ArgumentParser(description='Add site or delete site')
	opt_parser.add_argument('operation', action='store',
						choices=('add','del'),help='add or delete a site')
	opt_parser.add_argument('-o', '--owner', action='store',
						dest='owner', help='Site Owner')
	opt_parser.add_argument('server_name', action='store',
							help='Server Name')
	args = opt_parser.parse_args()

	if args.operation == 'add':
		owner = args.owner or os.getlogin()
		add_site(args.server_name, owner)
	else: #if args.operation == 'del':
		del_site(args.server_name)

	print
