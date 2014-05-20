#!/usr/bin/python

# user-admin set -m conke@maxwit.com conke

import os
from ConfigParser import ConfigParser
from argparse import ArgumentParser
from lib import base

def add_user(user, fname, password, mail, pgroup, apps):
	print 'Adding user %s ...\n' % user

	login = os.getenv('USER')
	if user == login:
		print "skipping current user!\n"
		exit()

	if base.user_exits(user):
		print 'user %s exists!' % user
		exit()

	if not base.group_exits(pgroup):
		print 'group %s does not exist!\n' % pgroup
		exit()

	os.system('useradd -g %s -m -s /bin/bash %s' % (pgroup,user))
	os.system('echo -e "%s\n%s" | passwd %s' % (password, password, user))

	os.system('usermod -c "%s" %s' % (fname, user))

	# run user-config.py -m mail (optional)

	if 'samba' in apps:
		print '\nadd samba account\n'
		os.system('echo -e "%s\n%s" | smbpasswd -s -a %s' % (password, password, user))

	print 'User %s Added!\n' % user

def del_user(user, apps):
	print "Delete user %s ..." % user

	login = os.getenv('USER')
	if user == login:
		print 'cannot delete current user!\n'
		exit()

	if not base.user_exits(user):
		print 'user %s does not exist!\n' % user
		exit()

	if 'samba' in apps:
		print 'Delete samba user %s ...' % user
		os.system('smbpasswd -d %s' % user)

	os.system('userdel -r %s\n' % user)

	print 'User %s Deleted!\n' % user

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root!'
		exit()

	version = 'v4.2'
	opt_parser = ArgumentParser(description='Add or del the user')

	opt_parser.add_argument('operation', action='store',
				choices=('add', 'del'), help='what you want to do to user')
	opt_parser.add_argument('user', action='store',
				help='user name')
	opt_parser.add_argument('-f', '--fullname', action='store', dest='fname',
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

	conf = {}
	for sect in cfg_parser.sections():
		for (key, value) in cfg_parser.items(sect):
			conf[sect + '.' + key] = value

	apps = conf.get('sys.apps', '').split()
	if args.operation == 'add':
		user = args.user
		fname = args.fname or args.user
		password = args.password or 'wit%s' % user
		mail = args.email or base.name_to_mail(fname)

		if conf.has_key('sys.group'):
			pgroup = conf['sys.group']
		else:
			print "Invalid configuration\n"
			exit()

		add_user(user, fname, password, mail, pgroup, apps)

	elif args.operation == 'del':
		user = args.user
		del_user(user, apps)
