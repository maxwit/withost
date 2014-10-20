#!/usr/bin/python

import os
from distrib import linux

class redhat(linux):
	def __init__(self, ostype):
		super(redhat, self).__init__(ostype)

	def app_install(self, install_list):
		os.system('yum install -y ' + install_list)

	def app_remove(self, install_list):
		os.system('yum remove -y ' + install_list)

	def service_start(self, service):
		if self.major <= 6:
			os.system('chkconfig %s on' % service)
			os.system('service %s restart' % service)
		else:
			os.system('systemctl enable ' + service)
			os.system('systemctl restart ' + service)

	def service_disable(self, service):
		if self.major <= 6:
			os.system('chkconfig %s off' % service)
		else:
			os.system('systemctl disable ' + service)

	def sys_init(self):
		if self.name != 'fedora':
			repos = [
				'http://rpms.famillecollet.com/enterprise/remi-release-%d.rpm' % self.major,
				]

			for repo in repos:
				print 'installing repo: ' + repo
				os.system('yum install -y ' + repo)

		# FIXME
		os.system('sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config')
		self.service_disable('iptables')
		self.service_disable('firewalld')