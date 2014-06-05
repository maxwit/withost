#!/usr/bin/python

import os, re, sys
import platform
from xml.etree import ElementTree
from distrib import unix

class osx(unix):
	def __init__(self, ostype):
		super(osx, self).__init__(ostype)
		self.repo = 'osx.xml'

	def app_install(self, install_list):
		os.system('brew install -y ' + install_list)

	def sys_init(self):
		os.system('''which brew || echo -e '\n' | ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"''')

	def set_hostname(self, host):
		os.system('scutil --set HostName ' + host)
