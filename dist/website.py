#!/usr/bin/python

import os
import shutil
from lib import base

def getbackend(dist, conf, apps):
	if conf.has_key('web.backend'):
		backend = conf['web.backend']
	else:
		backend = None

	return backend

def generate_path(server_type, server_name):
	if server_type == 'apache':
		if os.path.isdir('/etc/httpd/conf.d'):
			site_conf = '/etc/httpd/conf.d'
		elif os.path.isdir('/etc/apache2/sites-available'):
			site_conf = '/etc/apache2/sites-available'
		else:
			raise Exception('OS not supported!')

		site_root = '/var/www'
	else:
		if os.path.isdir('/etc/nginx/sites-available'):
			site_conf = '/etc/nginx/sites-available'
		elif os.path.isdir('/etc/nginx/conf.d'):
			site_conf = '/etc/nginx/conf.d'
		else:
			raise Exception('OS not supported!')

		site_root = '/usr/share/nginx'

	site_name = server_name.replace('.', '_')
	#site_name = server_name
	site_conf += '/' + site_name + '.conf'
	site_root += '/' + site_name

	return (site_conf, site_root)

def add_site(dist, server_type, server_name, owner, backend):
	print '%s: creating %s for %s ...' % (server_type.capitalize(), server_name, owner)

	(site_conf, site_root) = generate_path(server_type, server_name)
	if os.path.exists(site_conf):
		print 'The site "%s" already exists! (skipped)' % server_name
		return

	pattern = {'__DOCROOT__':site_root, '__SERVERNAME__':server_name}

	if backend is None:
		template = 'dist/site/%s.conf' % server_type
	else:
		template = 'dist/site/%s-%s.conf' % (server_type, backend)

		if backend == 'wsgi':
			main = 'main'
			pattern['__MAINDIR__'] = main

			# FIXME
			if server_type == 'apache':
				pattern['__PYTHONPATH__'] = site_root
		elif backend == 'uwsgi':
			#pattern['__PORT__'] = site_port
			pass

	if not os.path.exists(template):
		raise Exception(template + ' dost NOT exist!')

	print 'generating %s ...' % site_conf
	base.render_to_file(site_conf, template, pattern)

	if os.path.dirname(site_conf) == 'sites-available':
		os.symlink(site_conf, site_conf.replace('sites-available', 'sites-enable'))

	if backend == 'wsgi' or backend is None:
		print 'generating %s (%s) ...' % (site_root, backend or 'html')
		if backend == 'wsgi':
			pwd = os.getcwd()
			os.chdir(os.path.dirname(site_root))
			os.system('django-admin.py startproject ' + main)
			os.rename(main, os.path.basename(site_root))
			os.chdir(pwd)
		else:
			os.mkdir(site_root)
			base.render_to_file(site_root + '/index.html', 'dist/site/index.html', pattern)

		if dist[0].lower in ['ubuntu', 'mint']:
			group = 'www-data'
		else:
			group = server_type 

		# FIXME
		os.system('chown %s.%s -R %s' % (owner, group, site_root))
		os.system('chmod g+w -R ' + site_root)

def del_site(dist, server_type, server_name):
	print 'removing %s ...' % server_name

	(site_conf, site_root) = generate_path(server_type, server_name)

	if not os.path.exists(site_conf):
		print 'The site "%s" does not exist!' % server_name
		return

	if os.path.dirname(site_conf) == 'sites-available':
		os.remove(site_conf.replace('sites-available', 'sites-enable'))
	os.remove(site_conf)

	if os.path.exists(site_root):
		shutil.rmtree(site_root)
