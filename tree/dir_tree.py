#!/usr/bin/python

import os, re, sys
from xml.etree import ElementTree

# FIXME: to be removed
version = '4.2'

class dir_tree(object):
	def __init__(self, top, xml, group = None, mode = None):
		self.xml = 'tree/%s.xml' % xml
		self.top = top
		self.group = group
		self.mode = mode

	def populate(self):
		tree = ElementTree.parse(self.xml)
		root = tree.getroot()

		print '[%s]' % self.top

		try:
			self.__populate(root, self.top)
		except Exception, e:
			print e
			return

		readme = self.top + '/README.html'
		if not os.path.exists(readme):
			try:
				fd = open(readme, 'w+')
			except Exception, e:
				print e
				return

			fd.write('Created by MaxWit PowerTool v%s\n' % version)
			fd.close()

	def remove(self):
		pass

	def __populate(self, node, path):
		if not os.path.exists(path):
			print 'creating "%s"' % path
			os.mkdir(path)

			if self.mode is not None:
				os.chmod(path, self.mode)

			if self.group is not None:
				user = os.getenv('USER')
				# FIXME
				os.system("sudo chown %s.%s %s" % (user, self.group, path))
		else:
			print "skipping \"%s\"" % path

		for nd in node.getchildren():
			self.__populate(nd, path + '/' + nd.attrib['name'].strip())
