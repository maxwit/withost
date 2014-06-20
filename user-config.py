#!/usr/bin/python

import os, platform
import ConfigParser
from optparse import OptionParser
from user import rt_user
from tree import dir_tree

version = '4.3'

if __name__ == '__main__':
	if os.getuid() == 0:
		print 'pls do NOT run as root!'
		exit()

	opt_parser = OptionParser()
	opt_parser.add_option('-v', '--version', dest='version',
					  default=False, action='store_true',
					  help='show WitPowser version')

	(opt, args) = opt_parser.parse_args()

	if opt.version:
		print 'WitPowser v%s\nby MaxWit Software (http://www.maxwit.com)\n' % version
		exit()

	cfg_parser = ConfigParser.ConfigParser();
	try:
		cfg_parser.read('.config')
	except Exception, e:
		print e
		exit()

	conf = {}
	for sect in cfg_parser.sections():
		for (key, value) in cfg_parser.items(sect):
			conf[sect + '.' + key] = value

	user = rt_user.rt_user()
	print "User config: %s (%s)\n" % (user.fname, user.login)
	user.config(conf)

	tree = dir_tree.dir_tree(os.getenv('HOME'), 'home.xml')
	tree.populate()
	print
