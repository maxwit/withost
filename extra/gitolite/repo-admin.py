#!/usr/bin/python

import os
from argparse import ArgumentParser

version = '4.2'

server = '192.168.2.3'

def __repo_add(user, repo):
	print 'add %s for %s' % (repo, user)

	os.system('sudo -H -i -u git git clone --mirror git://%s/project/%s.git repositories/%s/%s.git'
			% (server, repo, user, repo))

	home = os.getenv('HOME')
	conf_fd = open(home + '/gitolite-admin/conf/gitolite.conf', 'a+')
	conf_fd.write('\n')
	conf_fd.write('repo %s/%s\n' % (user, repo))
	conf_fd.write('    RW+     =   @%s\n' % user)
	conf_fd.write('    R       =   @all\n')
	conf_fd.close()
	pwd = os.getcwd()
	os.chdir(home + '/gitolite-admin')
	os.system("git commit -asm 'add repo: %s/%s '" % (user,repo))
	os.system("git push")
	os.chdir(pwd)

def repo_add(user, repo):
	print '/home/git/repositories/%s/%s.git' % (user, repo)
	if os.path.exists('/home/git/repositories/%s/%s.git' % (user, repo)):
		print 'repo %s exists!' % repo
		return

	home = os.getenv('HOME')
	conf_fd = open(home + '/gitolite-admin/conf/gitolite.conf')
	for line in conf_fd:
		if line.startswith('@'):
			user_key = line.split('=')
			if user_key[0].strip() == '@' + user:
				__repo_add(user, repo)
				return
		elif line.strip() == '':
			break

	print 'Invalid user ' + user

def repo_del(user, repo):
	print 'delete %s of %s' % (repo, user)

if __name__ == '__main__':
	arg_parser = ArgumentParser(description='Add or del the user')
	arg_parser.add_argument('user', action='store', help='repo maintainer')
	arg_parser.add_argument('repo', action='store', help='repo name')
	arg_parser.add_argument('-v', '--version', action='version', version='WitHost %s' % version,
							help='show WitPowser version')

	arg = arg_parser.parse_args()

	if arg.user == None or arg.repo == None:
		print arg_parser.print_help()
		exit()

	repo_add(arg.user, arg.repo)
