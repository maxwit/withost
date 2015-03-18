#!/usr/bin/python

import os
import platform
import string
import shutil
import ConfigParser
from optparse import OptionParser

from dist import distrib
from tree import dir_tree

version = '5.2'

def xcopy(dir_src, dir_dst, ext):
	if not os.path.exists(dir_src):
		print '"%s" does not exist!'
		return

	src_list = os.listdir(dir_src)

	try:
		dst_list = os.listdir(dir_dst)
	except:
		dst_list = []

	for fn in src_list:
		src = '/'.join([dir_src, fn])
		dst = '/'.join([dir_dst, fn])

		if os.path.isdir(src):
			xcopy(src, dst, ext)
		elif fn.endswith(ext) and fn not in dst_list:
			parent = os.path.dirname(dst)
			if not os.path.exists(parent):
				os.makedirs(parent)
			print '%s -> %s' % (src, dst)
			shutil.copyfile(src, dst)

def cache_sync(distro, release, arch):
	if distro == 'ubuntu':
		dir_src = '/var/cache/apt/archives'
		ext = '.deb'
	elif distro in ['redhat', 'centos', 'fedora']:
		dir_src = '/var/cache/yum/%s/%s' % (arch, release.split('.')[0])
		ext = '.rpm'
	else:
		print distro + ' not supported!'
		exit(1)

	dir_dst = opt.path
	#/packages[/distro/release/arch/]
	dir_dst = '/'.join([dir_dst, distro, release, arch])

	xcopy(dir_src, dir_dst, ext)
	xcopy(dir_dst, dir_src, ext)

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = OptionParser()
	opt_parser.add_option('-s', '--sync', dest='path',
					  help='path to sync repo cache with')
	opt_parser.add_option('-v', '--version', dest='version',
					  default=False, action='store_true',
					  help='show WitHost version')

	(opt, args) = opt_parser.parse_args()

	if opt.version:
		print 'WitHost v%s\nby MaxWit Software (http://www.maxwit.com)\n' % version
		exit()

	if opt.path:
		(distro, release) = platform.dist()[0:2]
		arch = platform.processor()
		cache_sync(distro.lower(), release, arch)
		exit()

	try:
		dist = distrib.get_distro()
	except Exception, e:
		print e
		opt_parser.print_help()
		exit()

	print "System setup: %s %s\n" % (dist.name, dist.version)

	#if not os.path.exists('.config'):
	#	print '.config file does not exist!'

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

	if not conf.has_key('sys.apps'):
		print 'Invalid configuration!'
		exit()

	dist.sys_init()
	print
	dist.setup(conf)
	print
