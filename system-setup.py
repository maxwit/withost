#!/usr/bin/python

import os
import string
import ConfigParser
from optparse import OptionParser
from dist import distrib
from tree import dir_tree

version = '4.2'

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = OptionParser()
	opt_parser.add_option('-v', '--version', dest='version',
					  default=False, action='store_true',
					  help='show WitPower version')

	(opt, args) = opt_parser.parse_args()

	if opt.version:
		print 'WitPower v%s\nby MaxWit Software (http://www.maxwit.com)\n' % version
		exit()

	if not os.path.exists('.config'):
		print '.config file does not exist!'

	cfg_parser = ConfigParser.ConfigParser();
	try:
		cfg_parser.read('.config')
	except Exception, e:
		print e
		exit()

	try:
		dist = distrib.get_dist()
	except Exception, e:
		print e
		opt_parser.print_help()
		exit()

	print "System setup: %s %s\n" % (dist.name, dist.version)

	conf = {}
	for sect in cfg_parser.sections():	
		for (key, value) in cfg_parser.items(sect):
			conf[sect + '.' + key] = value
	
	if not conf.has_key('sys.apps'):
		print 'Invalid confuration'
		exit()

	dist.sys_init()
	print
	dist.setup(conf)
	print

	path = cfg_parser.get('pub', 'path')
	if path == None:
		print 'path path not configured!\n'
		exit()

	parent = os.path.dirname(path)
	if not os.access(parent, 5):
		print 'fail to access path "%s"!\n' % parent
		exit()

	mode = cfg_parser.get('pub', 'mode')
	tree = dir_tree.dir_tree(path, 'pub.xml', string.atoi(mode, 8))
	tree.populate()
	print

	# if pub.owner is None:
	user = os.getlogin()
	group = cfg_parser.get('sys', 'group')
	# FIXME
	try:
		os.system('groupadd ' + group)
		os.system('usermod -a -G %s %s' % (group, user))
	except Exception, e:
		print e
	os.system('chown %s.%s -R %s' % (user, group, path))
	print
