#!/usr/bin/python

import os

def setup(dist, conf, apps):
	admin = conf['sys.admin']

	if os.path.exists('/etc/incron.allow'):
		allow = open('/etc/incron.allow', 'r+')
		for line in allow:
			if line.strip() == admin:
				allow.close()
				return
	else:
		allow = open('/etc/incron.allow', 'w+')

	allow.write(admin + '\n')
	allow.close()
