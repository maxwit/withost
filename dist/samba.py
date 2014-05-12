#!/usr/bin/python

import os

def setup(dist, apps):
	src = '/etc/samba/smb.conf'
	dst = '/tmp/smb.conf'

	fsrc = open(src)
	fdst = open(dst, 'w+')

	for line in fsrc:
		entry = line.split('=')
		if len(entry) > 0 and entry[0].strip() == '[pub]':
			fsrc.close()
			fdst.close()
			return

		fdst.write(line)

	for (key, value) in [('comment', 'Public Stuff'), ('path', dist.pub), ('public', 'yes'), ('writable', 'no'), ('browseable', 'yes')]:
		fdst.write('\t%s = %s\n' % (key, value))

	fsrc.close()
	fdst.close()

	os.system("cp %s %s" % (dst, src))
