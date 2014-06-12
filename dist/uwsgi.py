import os
from lib import base

def setup(dist, conf, apps):
	# step 1: generate uwsgi.ini
	# base.render_to_file('uwsgi.ini', 'dist/site/uwsgi.ini', pattern)

	# step 2: create a default project (as following)
	if django in apps:
		#print 'generating %s (%s) ...' % (site_root, backend or 'UWSGI')
		#pwd = os.getcwd()
		#os.chdir(os.path.dirname(site_root))
		os.system('django-admin.py startproject ' + 'main')
		#os.rename(main, os.path.basename(site_root))
		#os.chdir(pwd)

	# step 3: enable and start the service
	# os.system('uwsgi --ini uwsgi.ini')

def remove(dist, conf, apps):
	pass
