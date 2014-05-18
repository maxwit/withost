#!/usr/bin/python

import os, re, sys
from xml.etree import ElementTree

# FIXME: to be removed
version = '4.2'

class dir_tree(object):
	def __init__(self, top, xml, mode = None):
		self.top = top
		self.xml = 'tree/' + xml
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

			fd.write('Created by MaxWit WitPowser v%s\n' % version)
			fd.close()

	def remove(self):
		pass

	def __populate(self, node, path):
		if not os.path.exists(path):
			print 'creating "%s"' % path
			os.mkdir(path)

			if self.mode is not None:
				os.chmod(path, self.mode)
		else:
			print "skipping \"%s\"" % path

		for nd in node.getchildren():
			self.__populate(nd, path + '/' + nd.attrib['name'].strip())
