#!/usr/bin/python

def setup(conf, apps):
	admin = conf['admin']

	allow = open('/etc/incron.allow', 'r+')
	for line in allow:
		if line.strip() == admin:
			allow.close()
			return

	allow.write(admin + '\n')
	allow.close()
