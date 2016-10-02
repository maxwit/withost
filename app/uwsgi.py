import os
from lib import base

def setup(dist, apps, conf):
	uwsgi_conf = '/etc/uwsgi.ini'
	# FIXME
	site_port = '9999'
	pattern = {'__PORT__':site_port}
	base.render_to_file(uwsgi_conf, app/site/uwsgi.ini', pattern)

	# FIXME
	if os.path.exists('/etc/rc.local'):
		with open('/etc/rc.local') as f:
			lines = f.readlines()

		for line in lines:
			if line.find(uwsgi_conf) > 0:
				return
		f.close()

		lines.insert(len(lines) - 1, 'uwsgi --uid nginx --ini %s\n' % uwsgi_conf)
		open('/etc/rc.local', 'w').writelines(lines)
	else:
		f = open('/etc/rc.local', 'w')
		f.write('#!/bin/bash\n')
		f.write('uwsgi --uid nginx --ini %s\n' % uwsgi_conf)
		f.write('exit 0')
		f.close()
		os.system("chmod +x /etc/rc.local")

def remove(dist, apps, conf):
	pass
