#!/usr/bin/python

import sys, os
import platform
import shutil

def usage():
	print "Usage: %s /path/to/packages/dir\n" % sys.argv[0]

def xcopy(dir_src, dir_dst, ext):
	src_list = os.listdir(dir_src)
	dst_list = os.listdir(dir_dst)

	for fn in set(src_list) - set(dst_list):
		src = '/'.join([dir_src, fn])
		dst = '/'.join([dir_dst, fn])

		if os.path.isdir(src):
			if not os.path.exists(dst):
				os.mkdir(dst)
			xcopy(src, dst, ext)
		elif fn.endswith(ext):
			print '%s -> %s' % (src, dst)
			shutil.copyfile(src, dst)

if os.getuid() != 0:
	print 'pls run as root or with sudo!'
	exit(1)

if len(sys.argv) != 2 or not os.path.isdir(sys.argv[1]):
	usage()
	exit(1)

(distro, release, codename) = platform.dist()
distro = distro.lower()

arch = platform.processor()

if distro == 'ubuntu':
	dir_src = '/var/cache/apt/archives'
	ext = '.deb'
elif distro in ['redhat', 'centos', 'fedora']:
	dir_src = '/var/cache/yum/%s/%s' % (arch, release.split('.')[0])
	ext = '.rpm'
else:
	print distro + ' not supported!'
	exit(1)

dir_dst = sys.argv[1]
#/packages[/distro/codename/arch/]
dir_dst = '/'.join([dir_dst, distro, codename, arch])

xcopy(dir_src, dir_dst, ext)
xcopy(dir_dst, dir_src, ext)
