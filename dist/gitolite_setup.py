#!/usr/bin/python

import os
import shutil

if not os.path.exists('.ssh/id_rsa.pub'):
	os.system('echo | ssh-keygen -N ""')

gitdir = '/tmp/gitkey/'
if not os.path.exists(gitdir):
	os.mkdir(gitdir, 0755)

f = open('.ssh/id_rsa.pub')
key = f.readline().split()[2].lower().replace('@', '_')
filename = key + '.pub'
f.close()
shutil.copy('.ssh/id_rsa.pub', gitdir + filename)

print 'gitolite setup with ' + filename
os.system('sudo -H -i -u git gitolite setup -pk ' + gitdir + filename)

if os.path.exists('gitolite-admin'):
	shutil.rmtree('gitolite-admin')
	
os.system('git clone git@127.0.0.1:gitolite-admin.git')
os.chdir('gitolite-admin')
f = open('conf/gitolite.conf')
lines = f.readlines()
f.close()

user = os.getlogin()
for i in range(len(lines)):
	lines[i] = lines[i].replace(key, '@devel')
lines.insert(0, '@devel = ' + key + '\n\n')
f = open('conf/gitolite.conf', 'w')
f.writelines(lines)
f.close()
os.system('git commit -asm "update gitolite.conf"')
os.system('git push')
