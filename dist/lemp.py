import os

def setup(dist, conf, apps):
	if 'python-pip' not in apps:
		print 'TODO: install pip'
		return

	os.system('pip install django')
