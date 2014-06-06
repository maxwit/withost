#!/usr/bin/python

import os
import shutil
from optparse import OptionParser

def gitolite_add():
	user = os.getlogin()
	path = os.getcwd()

	f = open('/etc/group')
	for line in f.readlines():
		s = line.split(":")[0].lower()
		if s == 'git':
			ret = os.system('useradd -g git -s /bin/bash -m git')
			break
	else:
		ret = os.system('useradd -s /bin/bash -m git')

	f.close()

	if ret != 0:
		exit()

	os.system('usermod -a -G git ' + user)
	os.system('sudo -H -i -u ' + user + ' python ' + path + '/dist/gitolite_add.py')

def gitolite_remove():
	user = os.getlogin()
	path = os.getcwd()
	os.system('sudo -H -i -u ' + user + ' python ' + path + '/dist/gitolite_remove.py')
	
	print 'deleteing user git'
	os.system('userdel -r -f git')

if __name__ == '__main__':
	option = OptionParser()
	option.add_option('-s', '--set', action='store', dest='option', help='setting')
	(opt, args) = option.parse_args()
	if opt.option == 'add':
		gitolite_add()
	elif opt.option == 'del':
		gitolite_remove()
