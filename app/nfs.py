#!/usr/bin/python

import os
import shutil

def setup(dist, apps):
	src = '/etc/exports'
	dst = '/tmp/nfs_exports'
	pub = conf['pub.path']

	fsrc = open(src)
	fdst = open(dst, 'w+')

	exist = False
	for line in fsrc:
		entry = line.split()
		if len(entry) > 0 and entry[0] == pub:
			fdst.write(pub + ' *(insecure,ro,async,no_subtree_check)\n')
			exist = True
		else:
			fdst.write(line)

	if not exist:
		fdst.write(pub + ' *(insecure,ro,async,no_subtree_check)\n')

	fsrc.close()
	fdst.close()

	shutil.copyfile(dst, src)
