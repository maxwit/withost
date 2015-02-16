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
		repos = [
			('remi', 'http://rpms.famillecollet.com/enterprise/remi-release-%d.rpm' % self.major),
			]

		for (name, repo) in repos:
			if not os.path.exists('/etc/yum.repos.d/%s.repo' % name):
				print 'installing repo: ' + name
				os.system('yum install -y ' + repo)
				os.system('yum-config-manager --enable ' + name)

		# FIXME
		os.system('sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config')
		self.service_disable('iptables')
		self.service_disable('firewalld')
