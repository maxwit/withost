#!/usr/bin/python

import os
from optparse import OptionParser
from ConfigParser import ConfigParser

version = 'v4.2'

def group_exits(group_name):
	fp_group = open('/etc/group', 'r')

	for line in fp_group:
		group = line.split(':')[0]
		if group_name == group:
			fp_group.close()
			return True

	fp_group.close()

	return False

def user_exits(user_name):
	fp_user = open('/etc/passwd', 'r')

	for line in fp_user:
		account = line.split(':')
		if user_name == account[0]:
			fp_user.close()
			return True

	fp_user.close()

	return False

def add_user(user_name, conf):
	print 'Adding user %s ...\n' % user_name

	login = os.getlogin()
	if user_name == login:
		print "skipping current user!\n"
		exit()

	if user_exits(user_name):
		print 'user %s exists!' % user_name
		exit()

	if conf.has_key('sys.group'):
		user_group = conf['sys.group']

		if not group_exits(user_group):
			print 'group %s does not exist!\n' % user_group
			exit()
	else:
		print "Invalid configuration\n"
		exit()

	password = 'wit%s' % user_name
	os.system('useradd -g %s -m -s /bin/bash %s' % (user_group,user_name))
	os.system('echo -e "%s\n%s" | passwd %s' % (password, password, user_name))
	os.system('usermod -c "%s" %s' % (user_name, user_name))

	apps = []
	if conf.has_key('sys.apps'):
		apps = conf['sys.apps'].split()

	if apps and 'samba' in apps:
		print '\nadd samba account\n'
		os.system('echo -e "%s\n%s" | smbpasswd -s -a %s' % (password, password, user_name))

	print 'User %s Added!\n' % user_name

def del_user(user_name, conf):
	print "Delete user %s ..." % user_name

	login = os.getlogin()
	if user_name == login:
		print 'cannot delete current user!\n'
		exit()

	if not user_exits(user_name):
		print 'user %s does not exist!\n'
		exit()

	apps = []
	if conf.has_key('sys.apps'):
		apps = conf['sys.apps'].split()

	if apps and 'samba' in apps:
		print 'Delete samba user %s ...' % user_name
		os.system('smbpasswd -d %s' % user_name)

	os.system('userdel -r %s' % user_name)

	print

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root!'
		exit()

	opt_parser = OptionParser()
	opt_parser.add_option('-a', '--add', dest='new_user',
							help = 'add a new user')
	opt_parser.add_option('-d', '--del', dest='del_user',
							help = 'delete user')
	opt_parser.add_option('-v', '--version', dest='version',
					  default=False, action='store_true',
					  help='show WitPowser version')
	opt_parser.version = version

	(opt, args) = opt_parser.parse_args()

	if opt.version:
		opt_parser.print_version()
		exit()

	cfg_parser = ConfigParser()

	ret = cfg_parser.read('.config')
	if not ret:
		print '".config" dose not exist!\n'
		exit()

	conf = {}
	for sect in cfg_parser.sections():
		for (key, value) in cfg_parser.items(sect):
			conf[sect + '.' + key] = value

	if opt.new_user:
		user_name = opt.new_user
		add_user(user_name, conf)

	elif opt.del_user:
		user_name = opt.del_user
		del_user(user_name, conf)

	else:
		opt_parser.print_help()
		exit()
