#!/usr/bin/python

import os
from dist import gitolite_setup

def install_gitolite():
	git_path = '/usr/share/gitolite'

	if not os.path.exists(git_path):
		#git clone git://github.com/sitaramc/gitolite.git $git_path
		#git clone git://github.com/maxwit/gitolite.git $git_path
		os.system('git clone git://192.168.1.1/project/gitolite.git ' + git_path)

	os.system(git_path + '/install -ln /usr/bin')

	link = os.readlink('/usr/bin/gitolite')
	print '/usr/bin/gitolite -> ' + link



def setup(dist, conf, apps):
	if 'gitolite' not in apps:
		install_gitolite()

	gitolite_setup.gitolite_add()
