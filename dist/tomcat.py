import os
from lib import base
from dist import website

def setup(dist, conf, apps):
	owner = os.getlogin()

	if 'tomcat7' in apps:
		tom_ver = 'tomcat7'
	else:
		tom_ver = 'tomcat'

	cata = '/etc/%s/Catalina/localhost' % tom_ver

	if not os.path.isdir(cata):
		raise Exception('tomcat.py: %s does not exist!' % cata)

	fronts = set(['apache', 'nginx']) and set(group_list)
	if len(fronts) == 1:
		server_type = fronts.pop()
	else:
		server_type = None

	for site in conf['web.site'].split():
		site_info = site.split('@')
		if len(site_info) != 2 or site_info[1] != 'tomcat':
			continue

		server_name = site_info[0]

		if server_type is not None:
			site_root = website.get_site_root(server_type, server_name)
		else:
			# FIXME
			site_root = "/var/lib/tomcat/webapps/"

		pattern = {'__DOCROOT__':site_root, '__SERVERNAME__':server_name}
		print 'Generating %s/%s.xml' % (cata, server_name)
		base.render_to_file('%s/%s.xml' % (cata, server_name), 'dist/site/tomcat.xml', pattern)

		print

def remove(dist, conf, apps):
	pass
