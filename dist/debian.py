#!/usr/bin/python

import os
from distrib import linux

class debian(linux):
	def __init__(self, ostype):
		super(debian, self).__init__(ostype)

	def app_install(self, install_list):
		os.system('apt-get install -y ' + install_list)

	def app_remove(self, install_list):
		os.system('apt-get remove --purge -y ' + install_list)

	def service_start(self, service):
		os.system('service %s restart' % service)

	def sys_init(self):
		#os.system('apt-get update -y')
		os.system('apt-get upgrade -y')
