#!/usr/bin/python

import os

def setup(dist, apps):
	if os.path.exists('/etc/vsftpd.conf'):
		src = '/etc/vsftpd.conf'
	elif os.path.exists('/etc/vsftpd/vsftpd.conf'):
		src = '/etc/vsftpd/vsftpd.conf'
	else:
		print 'vsftpd.conf does not exist!'
		return

	os.system('chmod +r ' + src)

	dst = '/tmp/vsftpd.conf'

	fsrc = open(src)
	fdst = open(dst, 'w+')

	exist = {}
	exist['local_root'] = dist.pub
	#exist['anon_root'] = dist.pub
	exist['anonymous_enable'] = 'NO'
	exist['write_enable'] = 'YES'

	for line in fsrc:
		entry = line.split('=')
		if len(entry) > 0:
			for (key, value) in exist.items():
				if entry[0].strip() == key:
					fdst.write('%s=%s\n' % (key, value))
					exist.pop(key)
					break
		else:
			fdst.write(line)

	for (key, value) in exist.items():
		fdst.write('%s=%s\n' % (key, value))

	fsrc.close()
	fdst.close()

	os.system("cp %s %s" % (dst, src))
