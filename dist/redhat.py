#!/usr/bin/python

import os, re, sys
import platform
from xml.etree import ElementTree
from distrib import unix

class redhat(unix):
	def __init__(self, ostype):
		super(redhat, self).__init__(ostype)

	def app_install(self, install_list):
		os.system('yum install -y ' + install_list)

	def app_remove(self, install_list):
		os.system('yum remove -y ' + install_list)

	def service_start(self, service):
		os.system('systemctl enable ' + service)
		os.system('systemctl restart ' + service)

	def service_disable(self, service):
		os.system('systemctl disable ' + service)

	def sys_init(self):
		#os.system('yum upgrade -y')

		os.system('sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config')

		self.service_disable('iptables')
		self.service_disable('firewalld')
