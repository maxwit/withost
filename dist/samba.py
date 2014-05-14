#!/usr/bin/python

import os
import shutil

def setup(dist, apps):
	src = '/etc/samba/smb.conf'
	dst = '/tmp/smb.conf'

	fsrc = open(src)
	fdst = open(dst, 'w+')

	for line in fsrc:
		entry = line.split('=')
		if entry[0].strip() == '[pub]':
			print src + ' leave unchanged'
			fsrc.close()
			fdst.close()
			return

		fdst.write(line)

	fdst.write('\n[pub]\n')
	for (key, value) in [('comment', 'Public Stuff'), ('path', dist.pub), ('public', 'yes'), ('writable', 'no'), ('browseable', 'yes')]:
		fdst.write('\t%s = %s\n' % (key, value))

	fsrc.close()
	fdst.close()

	shutil.copyfile(dst, src)
