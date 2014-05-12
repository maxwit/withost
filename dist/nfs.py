#!/usr/bin/python

import os

def setup(dist, apps):
	src = '/etc/exports'
	dst = '/tmp/nfs_exports'

	fsrc = open(src)
	fdst = open(dst, 'w+')

	exist = False
	for line in fsrc:
		entry = line.split()
		if len(entry) > 0 and entry[0] == dist.pub:
			fdst.write(dist.pub + ' *(insecure,ro,async,no_subtree_check)\n')
			exist = True
		else:
			fdst.write(line)

	if not exist:
		fdst.write(dist.pub + ' *(insecure,ro,async,no_subtree_check)\n')

	fsrc.close()
	fdst.close()

	os.system("cp %s %s" % (dst, src))
