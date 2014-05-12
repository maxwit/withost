#!/usr/bin/python

import os
import ConfigParser
from optparse import OptionParser
from dist import distrib

version = '4.2'

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = OptionParser()
	opt_parser.add_option('-v', '--version', dest='version',
					  default=False, action='store_true',
					  help='show PowerTool version')

	(opt, args) = opt_parser.parse_args()

	if opt.version:
		print 'PowerTool v%s\nby MaxWit Software (http://www.maxwit.com)\n' % version
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
			conf[key] = value
	
	if not conf.has_key('apps'):
		print 'Invalid confuration'
		exit()

	dist.sys_init()
	print

	dist.setup(conf)
	print
