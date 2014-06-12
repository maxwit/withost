#!/usr/bin/python

import os, re
import shutil
from argparse import ArgumentParser

def multiple_replace(text, sdict):
	rx = re.compile('|'.join(map(re.escape, sdict)))
	def one_xlat(match):
		return sdict[match.group(0)]
	return rx.sub(one_xlat, text)

def render_to_file(dst, src, pattern):
	fsrc = open(src)
	fdst = open(dst, 'w+')
	for line in fsrc:
		line = multiple_replace(line, pattern)
		fdst.write(line)
	fsrc.close()
	fdst.close()

def getbackend(dist, conf, apps):
	if conf.has_key('web.backend'):
		backend = conf['web.backend']
	else:
		backend = None

	return backend

def generate_path(server_type, server_name):
	if server_type == 'apache':
		site_root = '/var/www'

		if os.path.isdir('/etc/httpd/conf.d'):
			site_conf = '/etc/httpd/conf.d'
		elif os.path.isdir('/etc/apache2/sites-available'):
			site_conf = '/etc/apache2/sites-available'
		else:
			raise Exception('OS not supported!')
	else:
		site_root = '/usr/share/nginx'

		if os.path.isdir('/etc/nginx/sites-available'):
			site_conf = '/etc/nginx/sites-available'
		elif os.path.isdir('/etc/nginx/conf.d'):
			site_conf = '/etc/nginx/conf.d'
		else:
			raise Exception('OS not supported!')

	site_name = server_name.replace('.', '_')
	site_root += '/' + site_name
	site_conf += '/' + site_name + '.conf'

	return (site_conf, site_root)

def add_site(dist, server_type, server_name, owner, backend):
	print 'creating %s for %s ...' % (server_name, owner)

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
			pass

	if not os.path.exists(template):
		raise Exception(template + ' dost NOT exist!')

	print 'generating %s ...' % site_conf
	render_to_file(site_conf, template, pattern)

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
			render_to_file(site_root + '/index.html', 'dist/site/index.html', pattern)

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

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = ArgumentParser(description='Add site or delete site')
	opt_parser.add_argument('operation', action='store',
						choices=('add','del'),help='add or delete a site')
	opt_parser.add_argument('-t', '--type', action='store',
						dest='type', help='server type')
	opt_parser.add_argument('-b', '--back', action='store',
						dest='back', help='backend')
	opt_parser.add_argument('-o', '--owner', action='store',
						dest='owner', help='site owner')
	opt_parser.add_argument('server_name', action='store',
							help='server name')
	args = opt_parser.parse_args()

	if args.type:
		server_type = args.type
	else:
		server_type = 'nginx'

	if args.back:
		backend = args.back
	else:
		backend = None

	if args.operation == 'add':
		owner = args.owner or os.getlogin()
		add_site(('Fedora',), server_type, args.server_name, owner, backend)
	else: #if args.operation == 'del':
		del_site(('Fedora',), server_type, args.server_name)

	print
