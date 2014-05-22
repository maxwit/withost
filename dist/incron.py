#!/usr/bin/python

import os

def setup(dist, conf, apps):
	fn = '/etc/incron.allow'
	admin = os.getlogin()

	if os.path.exists(fn):
		allow = open(fn, 'r+')
		for line in allow:
			if line.strip() == admin:
				allow.close()
				return
	else:
		allow = open(fn, 'w+')

	allow.write(admin + '\n')
	allow.close()
