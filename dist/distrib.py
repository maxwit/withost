#!/usr/bin/python

import os
import platform
from xml.etree import ElementTree

class linux(object):
	def __init__(self, ostype):
		self.name = ostype[0]
		# FIXME: to be removed
		self.version = ostype[1]
		self.major = int(self.version.split('.')[0])
		self.minor = int(self.version.split('.')[1])
		self.arch = platform.processor()
# 		self.host = platform.node()

	def sys_init(self):
		pass

	def app_install(self, app_list):
		pass

	def app_remove(self, app_list):
		pass

	def pip_install(self, app_list):
		os.system('pip install ' + app_list)

	def pip_remove(self, app_list):
		os.system('pip uninstall -y ' + app_list)

	def service_start(self, service):
		print 'service_start: %s not supported' % self.name

	def setup(self, config):
		install_list = config['sys.apps'].split()

		tree = ElementTree.parse('app/app.xml')
		root = tree.getroot()

		for dist_node in root.getchildren():
			if self.name in dist_node.attrib['name'].split():
				for release in dist_node.getchildren():
					version = release.attrib['version']
					if version == 'any' or self.version.lower() in version.split():
						self.do_setup(release, config, install_list)

				if len(install_list) != 0:
					print '#########################'
					print '##       Warning      ##'
					print '#########################'
					print 'Application(s) NOT installed:', install_list
					print

				return

		print '%s %s: no app config found!' % (self.name, self.version)

	def do_setup(self, release, config, install_list):
		for app_node in release.getchildren(): # FIXME: in install_list instead
			if self.arch != app_node.get('arch', self.arch):
				continue

			group = app_node.get('group')
			if group not in install_list:
				continue
			install_list.remove(group)

			print '[%s]\n%s' % (group, app_node.text)
			install = app_node.get('install', None)
			if install is None:
				self.app_install(app_node.text)
			elif install == 'pip':
				self.pip_install(app_node.text)
			else:
				raise Exception('Bug!')

			if os.path.exists('app/%s.py' % group):
				print 'Setup %s ...' % group
				try:
					mod = __import__('app.' + group, fromlist=['setup'])
					mod.setup((self.name, self.version), config, app_node.text.split())
					# mod.setup((self.name, self.version), config, (group, app_list))
				except Exception, e:
					print '%r\n' % e
					continue

			service_list = app_node.get('service', '')
			for service in service_list.split():
				self.service_start(service)
				print 'service %s started' % service

			print

def get_distro():
	os_type = platform.system()

	if os_type != 'Linux':
		raise Exception(os_type + ' NOT supported!')

	(dist_name, version) = platform.dist()[0:2]

	dist_name = dist_name.lower()

	ver = version.split('.')
	if len(ver) > 2:
		version = '.'.join([ver[0], ver[1]])

	if dist_name in ['debian', 'ubuntu', 'mint']:
		from debian import debian
		dist = debian((dist_name, version))
	elif dist_name in ['redhat', 'fedora', 'centos', 'olinux']:
		from redhat import redhat
		dist = redhat((dist_name, version))
	else:
		raise Exception(dist_name + ' NOT supported!')

	return dist
