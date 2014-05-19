#!/usr/bin/python

import os, urllib, zipfile, shutil

def setup(conf, apps):
	url = 'http://mirrors.ctan.org/macros/latex/contrib'
	pkgs = ['draftwatermark', 'everypage', 'multirow']
	dst = '/usr/share/texlive/texmf-dist/tex/latex/'

	cur_path = os.path.abspath('.')
	os.chdir('/tmp')
	for pkg in pkgs:
		if os.path.exists(dst + pkg):
			print pkg + ' has already be installed!'
			continue

		pkg_file = pkg + '.zip'
		if not os.path.exists(pkg):
			if not os.path.exists(pkg_file):
				print 'Download ' + pkg_file + ' start.'
				urllib.urlretrieve('%s/%s.zip' % (url, pkg), filename = pkg_file)
				print 'Download ' + pkg_file + ' finish.'

			z = zipfile.ZipFile(pkg_file)
			for name in z.namelist():
				if name.endswith('/'):
					os.makedirs(name)
				else:
					data = z.read(name)
					f = open(name, 'w+b')
					f.write(data)
					f.close()

		if not os.path.exists('%s/%s.sty' % (pkg, pkg)):
			os.chdir(pkg)
			if os.path.exists(pkg + '.ins'):
				os.system('xelatex ' + pkg + '.ins')
			elif os.path.exists(pkg + '.dtx'):
				os.system('xelatex ' + pkg + '.dtx')
			else:
				print 'error: can not generate ' + pkg + '.sty'

		os.chdir('/tmp')
                shutil.copytree(pkg, dst + pkg)

	os.chdir(cur_path)
	os.system('texhash')
