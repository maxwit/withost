#!/usr/bin/python

import os
import shutil

def setup(conf, apps):
	git_path = '/usr/share/gitolite'

	if not os.path.exists(git_path):
		#git clone git://github.com/sitaramc/gitolite.git $git_path
		#git clone git://github.com/maxwit/gitolite.git $git_path
		os.system('git clone git://192.168.1.1/project/gitolite.git ' + git_path)

	os.system(git_path + '/install -ln /usr/bin')
