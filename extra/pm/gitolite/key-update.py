#!/usr/bin/python

import os, sys
import shutil
import fileinput
import pwd

def key_update(src):
	home = os.getenv('HOME')
	log = home + '/.gitolite.log'
	keydir = home + '/gitolite-admin/keydir'

	os.chdir(home)

	fp_log = open(log, 'a')
	fp_log.write('[%s]\n' % src)

	ga = 'gitolite-admin'
	if os.path.exists(ga):
		os.chdir(ga)
		os.system('git pull')
	else:
		os.system('git clone git@127.0.0.1:gitolite-admin.git')
		os.chdir(ga)

	try:
		fp_rsa = open(src, 'r')
	except Exception, e:
		print e

		fp_log.write('%s does NOT exists!\n' % src)
		fp_log.write('\n')

		fp_log.close()

		exit()

	sig = ''
	for line in fp_rsa:
		sig = line.split()[0]
		break

	if sig != 'ssh-rsa':
		print 'invalid %s' % src
		fp_log.write('invalid %s:\n' % src)

		fp_rsa.seek(0)
		for line in fp_rsa:
			fp_log.write(line)
		fp_log.write('\n')

		exit()

	key = ''
	fp_rsa.seek(0)
	for line in fp_rsa:
		key = line.split()[2]
		key = key.replace('@', '-')
		break

	dst = key + '.pub'

	conf = 'conf/gitolite.conf'
	if os.path.exists(keydir + '/' + dst):
		shutil.copyfile(src, keydir + '/' + dst)
		os.system('git commit -asm "update %s"' % dst)

		fp_log.write('update %s\n' % dst)

	else:
		shutil.copyfile(src, keydir + '/' + dst)
		user = '@' + pwd.getpwuid(os.stat(src).st_uid).pw_name

		with open(conf) as f:
			lines = f.readlines()

		flag = False
		for i in range(len(lines)):
			s = lines[i].split()

			if s and s[0] == user:
				lines[i] = user + ' = ' + key + '\n'
				flag = True
				break

		if not flag:
			lines.insert(0, user + ' = ' + key + '\n');

		open(conf, 'w').writelines(lines);

		os.system('git add %s/%s' % (keydir, dst))
		os.system('git commit -asm "add %s"' % dst)

		fp_log.write('add %s\n' % dst)

	os.system('git push')
	fp_log.write('\n')
	os.system('sudo rm -f ' + src)

	fp_rsa.close()
	fp_log.close()

if __name__ == '__main__':
	key_update(sys.argv[1])
