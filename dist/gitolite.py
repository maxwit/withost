#!/usr/bin/python

import os
import shutil

def setup(conf, apps):
	top = os.getcwd()

	os.system('useradd -m -s /bin/bash git')
	os.system('sudo -H -i -u git %s/dist/git/install.sh' % top)

	admin = conf['admin']
	tmp_dir = '/tmp' # FIXME
	os.system('sudo -H -i -u %s %s/dist/git/init.sh %s' % (admin, top, tmp_dir))

	src = tmp_dir + '/id_rsa.pub'
	lines = open(src).readlines()
	if len(lines) != 1:
		raise Exception('%s is invalid! lines = %d' % (src, len(lines)))

	sign = lines[0].split()
	if len(sign) != 3 or sign[0] != 'ssh-rsa':
		raise Exception('%s is invalid: %s' % (src, lines[0]))

	key = sign[2].replace('@', '-').lower()
	dst = '%s/%s.pub' % (tmp_dir, key)
	os.rename(src, dst)

	print 'gitolite setup with %s:' % dst
	os.system('sudo -H -i -u git gitolite setup -pk ' + dst)

	os.remove(dst)

#remove()
#{
#	incrontab -r
#	rm -rf $HOME/gitolite-admin
#	echo
#
#	echo "deleting user git"
#	sudo userdel -r -f git
#}
#
#if __name__ == '__main__':
#	config()
