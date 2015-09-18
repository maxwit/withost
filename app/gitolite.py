#!/usr/bin/python

import os
from optparse import OptionParser
from lib import base

def install_gitolite():
	git_path = '/usr/share/gitolite-master'

	if not os.path.exists(git_path):
		#git clone git://github.com/sitaramc/gitolite.git $git_path
		#git clone git://github.com/maxwit/gitolite.git $git_path
		#os.system('git clone git://github.com/sitaramc/gitolite.git ' + git_path)
		url = "https://github.com/sitaramc/gitolite/archive/master.zip"
		os.system("wget -P /tmp " + url)
		#urllib.urlretrieve(url, pkg_file, base.process)
		os.system("unzip -d %s /tmp/master.zip" % os.path.dirname(git_path))

	os.system(git_path + '/install -ln /usr/bin')

	link = os.readlink('/usr/bin/gitolite')
	print '/usr/bin/gitolite -> ' + link

def setup(dist, apps, conf):
	#if 'gitolite' not in apps:
	#	install_gitolite()

	gitolite_setup()

def gitolite_setup():
	user = os.getlogin()
	path = os.getcwd()

	if not base.user_exists('git'):
		if base.group_exists('git'):
			ret = os.system('useradd -s /bin/bash -m -g git git')
		else:	
			ret = os.system('useradd -s /bin/bash -m git')

		if ret != 0:
			raise Exception('Fail to create user "git"!')

	#os.system('usermod -a -G git ' + user)
	os.system('sudo -H -i -u ' + user + ' python ' + path + '/dist/gitolite_setup.py')

def gitolite_remove():
	user = os.getlogin()
	path = os.getcwd()
	os.system('sudo -H -i -u ' + user + ' python ' + path + '/dist/gitolite_remove.py')

	print 'deleteing user git'
	os.system('userdel -r -f git')

if __name__ == '__main__':
	option = OptionParser()
	option.add_option('-r', '--remove', dest='remove', 
					default=False, action='store_true', help='remove gitolite')
	(opt, args) = option.parse_args()
	if opt.remove:
		gitolite_remove()
	else:
		gitolite_setup()
