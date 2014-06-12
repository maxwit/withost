import os
from lib import base
from dist import website

def add_site(dist, server_type, server_name, owner):
	# step 1: generate uwsgi.ini
	#site_conf = website.get_site_conf()
	site_conf = '/etc/uwsgi.ini'
	site_root = website.get_site_root(server_type, server_name)

	pattern = {'__DOCROOT__':site_root, '__SERVERNAME__':server_name}
	main = 'main'
	pattern['__MAINDIR__'] = main
	base.render_to_file(site_conf, 'dist/site/uwsgi.ini', pattern)

	# step 2: create a default project (as following)
	#if 'django' in apps:
	print 'generating %s (%s) ...' % (site_root, 'UWSGI')
	pwd = os.getcwd()
	os.chdir(os.path.dirname(site_root))
	os.system('django-admin.py startproject ' + main)
	os.rename(main, os.path.basename(site_root))
	os.chdir(pwd)

	# FIXME
	group = owner
	os.system('chown %s.%s -R %s' % (owner, group, site_root))
	os.system('chmod g+w -R ' + site_root)

	# step 3: enable and start the service
	os.system('uwsgi --ini %s &' % site_conf)

def setup(dist, conf, apps):
	owner = os.getlogin()
	for server_name in conf['web.site'].split():
		add_site(dist, 'uwsgi', server_name, os.getlogin())
		print

def remove(dist, conf, apps):
	pass
