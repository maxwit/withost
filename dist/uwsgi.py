import os
from lib import base

def setup(dist, conf, apps):
	uwsgi_conf = '/etc/uwsgi.ini'
	# FIXME
	site_port = '9999'
	pattern = {'__PORT__':site_port}
	base.render_to_file(uwsgi_conf, 'dist/site/uwsgi.ini', pattern)

	# FIXME
	# os.system('uwsgi --ini %s &' % uwsgi_conf)
	if (os.path.exists('/etc/rc.local')):
		with open('/etc/rc.local') as f:
			lines = f.readlines()
		lines.insert(len(lines) - 1, 'uwsgi --ini %s\n' % uwsgi_conf)
		open('/etc/rc.local', 'w').writelines(lines)

def remove(dist, conf, apps):
	pass
