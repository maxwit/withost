#!/usr/bin/python

import os
from dist import gitolite_setup

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

def setup(dist, conf, apps):
	if 'gitolite' not in apps:
		install_gitolite()

	gitolite_setup.gitolite_add()
