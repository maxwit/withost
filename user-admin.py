#!/usr/bin/python

# user-admin set -m conke@maxwit.com conke

import os
from ConfigParser import ConfigParser
from argparse import ArgumentParser

version = 'v4.2'
conf = {}

def group_exits(group):
	fp_group = open('/etc/group', 'r')

	for line in fp_group:
		group = line.split(':')[0]
		if group == group:
			fp_group.close()
			return True

	fp_group.close()

	return False

def user_exits(user):
	fp_user = open('/etc/passwd', 'r')

	for line in fp_user:
		account = line.split(':')
		if user == account[0]:
			fp_user.close()
			return True

	fp_user.close()

	return False

def add_user(user, full_name, password, mail, group):
	print 'Adding user %s ...\n' % user

	login = os.getenv('USER')
	if user == login:
		print "skipping current user!\n"
		exit()

	if user_exits(user):
		print 'user %s exists!' % user
		exit()

	if conf.has_key('sys.group'):
		group = conf['sys.group']

		if not group_exits(group):
			print 'group %s does not exist!\n' % group
			exit()
	else:
		print "Invalid configuration\n"
		exit()

	os.system('useradd -g %s -m -s /bin/bash %s' % (group,user))
	os.system('echo -e "%s\n%s" | passwd %s' % (password, password, user))

	os.system('usermod -c "%s" %s' % (full_name, user))

	# run user-config.py -m mail (optional)

	apps = []
	if conf.has_key('sys.apps'):
		apps = conf['sys.apps'].split()

	if apps and 'samba' in apps:
		print '\nadd samba account\n'
		os.system('echo -e "%s\n%s" | smbpasswd -s -a %s' % (password, password, user))

	print 'User %s Added!\n' % user

def del_user(user):
	print "Delete user %s ..." % user

	login = os.getenv('USER')
	if user == login:
		print 'cannot delete current user!\n'
		exit()

	if not user_exits(user):
		print 'user %s does not exist!\n' % user
		exit()

	apps = []
	if conf.has_key('sys.apps'):
		apps = conf['sys.apps'].split()

	if apps and 'samba' in apps:
		print 'Delete samba user %s ...' % user
		os.system('smbpasswd -d %s' % user)

	os.system('userdel -r %s' % user)

	print

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root!'
		exit()

	opt_parser = ArgumentParser(description='Add or del the user')

	opt_parser.add_argument('operation', action='store',
				choices=('add', 'del'), help='what you want to do to user')
	opt_parser.add_argument('user', action='store',
				help='user name')
	opt_parser.add_argument('-f', '--full_name', action='store', dest='full_name',
							help='full name')
	opt_parser.add_argument('-m', '--mail',  action='store', dest='email',
							help='e-mail')
	opt_parser.add_argument('-p', '--password', action='store', dest='password',
							help='password')
	opt_parser.add_argument('-v', '--version', action='version', version='WitPower %s' % version,
							help='show WitPowser version')

	args = opt_parser.parse_args()

	cfg_parser = ConfigParser()

	ret = cfg_parser.read('.config')
	if not ret:
		print '".config" dose not exist!\n'
		exit()

	for sect in cfg_parser.sections():
		for (key, value) in cfg_parser.items(sect):
			conf[sect + '.' + key] = value

	if args.operation == 'add':
		user = args.user
		full_name = args.full_name or args.user
		password = args.password or 'wit%s' % user
		mail = args.email or user + '@maxwit.com'
		group = conf['sys.group']

		add_user(user, full_name, password, mail, group)

	elif args.operation == 'del':
		user = args.user
		del_user(user)
