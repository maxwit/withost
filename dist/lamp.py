#!/usr/bin/python

import os
from dist import site_admin

def setup(dist, conf, apps):
	os.system('pip install MySQL-python')

	site = conf['web.site'].split()
	sitename = [site[0].replace('.', '_'), site[1].replace('.', '_')]
	print sitename
	site_admin.add_site(site[0], sitename[0], os.getlogin())
	site_admin.add_site(site[1], sitename[1], os.getlogin())
