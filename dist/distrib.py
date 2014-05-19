#!/usr/bin/python

import os
import platform
from xml.etree import ElementTree

class distrib(object):
	def __init__(self, ostype):
		self.name = ostype[0]
		self.version = ostype[1]
		self.arch = platform.processor()
		self.host = platform.node()

	def sys_init(self):
		pass

	def app_install(self, app_list):
		pass

	def service_start(self, service):
		print 'service_start: %s not supported' % self.name

	def set_hostname(self, host):
		# TODO
		# open('/etc/hostname', 'w+').write(host)
		os.system('echo %s > /etc/hostname' % host)
		os.system('hostname ' + host)

	def setup(self, config):
		# TODO: move to sys_init()
		if config.has_key('sys.host'):
			host = config['sys.host']
		else:
			# TODO: use a better name?
			host = self.name

		if host != self.host:
			self.set_hostname(host)
			self.host = host

		print 'HostName = "%s"\n' % self.host

		self.app_setup(config)

	def app_setup(self, config):
		install_list = config['sys.apps'].split()

		tree = ElementTree.parse('dist/%s' % self.repo)
		root = tree.getroot()

		for dist_node in root.getchildren():
			if dist_node.attrib['name'].lower() == self.name.lower():
				break

		for release in dist_node.getchildren():
			version = release.attrib['version']
			if version == 'any' or version.lower() == self.version.lower():
				for app_node in release.getchildren():
					if self.arch != app_node.get('arch', self.arch):
						continue

					group = app_node.get('group')
					if group not in install_list:
						continue
					install_list.remove(group)

					print '[%s]\n%s' % (group, app_node.text)
					self.app_install(app_node.text)

					if os.path.exists('dist/%s.py' % group):
						print 'Setup %s ...' % group
						try:
							mod = __import__('dist.' + group, fromlist = ['setup'])
							mod.setup((self.name, self.version), config, app_node.text.split())
						except Exception, e:
							print '%r\n' % e
							continue

					service_list = app_node.get('service', '')
					for service in service_list.split():
						self.service_start(service)
						print 'service %s started' % service

					print

		if len(install_list) != 0:
			print '#########################'
			print '##       Warning      ##'
			print '#########################'
			print 'Application(s) NOT installed:', install_list
			print

def get_dist():
	os_type = platform.system()

	if os_type == 'Linux':
		dist_name = platform.dist()[0]

		version = platform.dist()[1]
		ver = version.split('.')
		if len(ver) > 2:
			version = '%s.%s' % (ver[0], ver[1])

		if dist_name in ['Debain', 'Ubuntu', 'Mint']:
			from debian import debian
			dist = debian((dist_name, version))
		elif dist_name in ['redhat', 'fedora', 'centos', 'OLinux']:
			from redhat import redhat
			dist = redhat((dist_name, version))
		else:
			raise Exception(dist_name + ' NOT supported!')
	elif os_type == 'Darwin':
		from osx import osx

		dist_name = 'OS X'
		version = platform.mac_ver()[0]
		dist = osx((ditrib, version))
	else:
		if os_type == 'Windows':
			version = platform.win32_ver()[0]
			os_type = os_type + ' ' + version

		raise Exception(os_type + ' NOT supported!')

	return dist
