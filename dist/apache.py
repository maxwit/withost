#!/usr/bin/python

import os, re
import shutil
from dist import website

def setup(dist, conf, apps):
	owner = os.getlogin()
	backend = website.get_backend(dist, conf, apps)

	for server_name in conf['web.site'].split():
		website.add_site(dist, 'apache', server_name, owner, backend)
		print

def remove(dist, conf, apps):
	for server_name in conf['web.site'].split():
		website.del_site(dist, 'apache', server_name)
