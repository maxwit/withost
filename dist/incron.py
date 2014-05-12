#!/usr/bin/python

import os

def setup(dist, apps):
	fn = '/etc/incron.allow'
	if not os.path.exists(fn):
		os.system('touch ' + fn)
