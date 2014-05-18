#!/usr/bin/python

import os, re, sys
import platform
from xml.etree import ElementTree

class rt_user(object):
	def __init__(self):
		self.login = os.getenv('USER')
		self.home = os.getenv('HOME')
		self.fname = self.get_user_info()
		mail_user = self.fname.lower().replace(' ', '.')
		if self.fname == mail_user:
			print 'Please make sure your mail account (%s) is correct!' % self.email
		# FIXME: detect the Windows domain
		self.email = mail_user + '@maxwit.com'

	def get_user_info(self):
		fd_rept = open('/etc/passwd', 'r')
		full_name = ''

		for line in fd_rept:
			account = line.split(':')
			user_name = account[0]
			if user_name == self.login:
				full_name = account[4].split(',')[0]
				break

		fd_rept.close()

		if full_name != '':
			return full_name
		return self.login

	def config(self, conf):
		if not os.path.exists(self.home + '/.ssh/id_rsa.pub'):
			os.system("echo | ssh-keygen -N ''")

			fd_config = open(self.home + '/.ssh/config', 'w')
			fd_config.write("StrictHostKeyChecking no")
			fd_config.close()
			os.chmod(self.home + '/.ssh/config', 0600)

		if not conf.has_key('apps'):
			return

		for app in conf['apps'].split():
			if not os.path.exists('user/%s.py' % app):
				continue

			print 'Configuring %s:' % app

			try:
				mod = __import__('user.%s' % app, fromlist = ['config'])
				rc = mod.config(self, app)
			except Exception, e:
				print "%r\n" % e
				continue

			for fn in rc:
				print fn

			print
