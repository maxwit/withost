#!/usr/bin/python

import os
import shutil
from lib import base

def get_backend(dist, conf, apps):
	if conf.has_key('web.backend'):
		backend = conf['web.backend']
		if backend.lower() == 'none':
			backend = None
	else:
		for be in ['wsgi', 'uwsgi', 'tomcat']:
			if be in apps:
				backend = be
				break
		else:
			backend = None

	return backend

def get_site_root(server_type, server_name):
	#if conf.has_key('web.root'):
	#	site_root = conf['web.root']
	if server_type == 'nginx':
		site_root = '/usr/share/nginx'
	else: #if server_type == 'apache':
		site_root = '/var/www'

	site_name = server_name.replace('.', '_')
	#site_name = server_name
	site_root += '/' + site_name

	return site_root

def get_site_conf(server_type, server_name):
	if server_type == 'apache':
		if os.path.isdir('/etc/httpd/conf.d'):
			site_conf = '/etc/httpd/conf.d'
		elif os.path.isdir('/etc/apache2/sites-available'):
			site_conf = '/etc/apache2/sites-available'
		else:
			raise Exception('OS not supported!')
	elif server_type == 'nginx':
		if os.path.isdir('/etc/nginx/sites-available'):
			site_conf = '/etc/nginx/sites-available'
		elif os.path.isdir('/etc/nginx/conf.d'):
			site_conf = '/etc/nginx/conf.d'
		else:
			raise Exception('OS not supported!')
	else:
		raise Exception('server "%s" not supported!' % server_type)

	site_name = server_name.replace('.', '_')
	#site_name = server_name
	site_conf += '/' + site_name + '.conf'

	return site_conf

def add_site(dist, server_type, server_name, owner, backend):
	print '%s: creating %s for %s ...' % (server_type.capitalize(), server_name, owner)

	site_conf = get_site_conf(server_type, server_name)
	if os.path.exists(site_conf):
		print 'The site "%s" already exists! (skipped)' % server_name
		return

	site_root = get_site_root(server_type, server_name)
	pattern = {'__DOCROOT__':site_root, '__SERVERNAME__':server_name}

	if backend is None:
		template = 'dist/site/%s.conf' % server_type
	else:
		template = 'dist/site/%s-%s.conf' % (server_type, backend)

		if server_type == 'apache' and backend == 'wsgi':
			pattern['__PYTHONPATH__'] = site_root

	if not os.path.exists(template):
		raise Exception(template + ' dost NOT exist!')

	print 'generating %s ...' % site_conf
	base.render_to_file(site_conf, template, pattern)

	if os.path.dirname(site_conf) == 'sites-available':
		os.symlink(site_conf, site_conf.replace('sites-available', 'sites-enable'))

	print 'generating %s (%s) ...' % (site_root, backend or 'html')

	if backend is None:
		os.mkdir(site_root)
		base.render_to_file(site_root + '/index.html', 'dist/site/index.html', pattern)
	elif backend in ['wsgi', 'uwsgi']:
		pwd = os.getcwd()
		os.chdir(os.path.dirname(site_root))
		os.system('django-admin.py startproject main')
		os.rename('main', os.path.basename(site_root))
		os.chdir(pwd)
	else:
		print 'Warning: init site for "%s" is ignored!' % backend
		return

	if dist[0].lower in ['ubuntu', 'mint']:
		group = 'www-data'
	else:
		group = server_type

	# FIXME
	os.system('chown %s.%s -R %s' % (owner, group, site_root))
	os.system('chmod g+w -R ' + site_root)

def del_site(dist, server_type, server_name):
	print 'removing %s ...' % server_name

	site_conf = get_site_conf(server_type, server_name)
	if not os.path.exists(site_conf):
		print 'The site "%s" does not exist!' % server_name
		return

	if os.path.dirname(site_conf) == 'sites-available':
		os.remove(site_conf.replace('sites-available', 'sites-enable'))
	os.remove(site_conf)

	site_root = get_site_root(server_type, server_name)
	if os.path.exists(site_root):
		shutil.rmtree(site_root)
