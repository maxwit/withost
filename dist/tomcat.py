import os
from lib import base
from dist import website

def add_site(dist, server_type, server_name, owner):
	site_root = website.get_site_root(server_type, server_name)
	pattern = {'__DOCROOT__':site_root, '__SERVERNAME__':server_name}
	# FIXME: fix path for CentOS 6.x
	base.render_to_file('/var/lib/tomcat7/Catalina/localhost/%s.xml' % server_name, 'dist/site/tomcat.xml', pattern)

def setup(dist, conf, apps):
	return
	owner = os.getlogin()
	for server_name in conf['web.site'].split():
		add_site(dist, 'tomcat', server_name, os.getlogin())
		print

def remove(dist, conf, apps):
	pass
