#!/usr/bin/python

import os
import ConfigParser
from optparse import OptionParser
from tree import dir_tree
from dist import distrib

version = '4.2'

if __name__ == '__main__':
	if os.getuid() == 0:
		print 'pls do NOT run as root!'
		exit()

	opt_parser = OptionParser()
	opt_parser.add_option('-t', '--tree', dest='tree',
					  help='directory tree to be populated')
	opt_parser.add_option('-l', '--list', dest='list',
					  default=False, action='store_true',
					  help='show available tree configuration')
	opt_parser.add_option('-v', '--version', dest='version',
					  default=False, action='store_true',
					  help='show PowerTool version')

	(opt, args) = opt_parser.parse_args()

	if opt.version:
		print 'PowerTool v%s\nby MaxWit Software (http://www.maxwit.com)\n' % version
		exit()

	if opt.list:
		print '\tpub\n\thome\n'
		exit()

	if opt.tree == None or not os.path.exists('tree/%s.xml' % opt.tree):
		opt_parser.print_help()
		exit()

	if not os.path.exists('.config'):
		print '.config file does not exist!\n'
		exit()

	cfg_parser = ConfigParser.ConfigParser();
	try:
		cfg_parser.read('.config')
	except Exception, e:
		print e
		exit()

	print "Directory population: %s\n" % opt.tree

	if opt.tree == 'home':
		path = os.getenv('HOME')
		tree = dir_tree.dir_tree(path, opt.tree)
	else:
		path = cfg_parser.get(opt.tree, 'path')
		if path == None:
			print 'path path not configured!\n'
			exit()

		parent = os.path.dirname(path)
		if not os.access(parent, 7):
			print 'fail to access path "%s"!\n' % parent
			exit()

		group = cfg_parser.get(opt.tree, 'group')
		mode = cfg_parser.getint(opt.tree, 'mode')
		tree = dir_tree.dir_tree(path, opt.tree, group, mode)

	tree.populate()

	print
