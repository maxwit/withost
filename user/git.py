import os

def config(dist, apps):
	git = {}
	git['color.ui'] = 'auto'
	git['user.name'] = dist.fname
	git['user.email'] = dist.email
	git['sendemail.smtpserver'] = '/usr/bin/msmtp'
	git['push.default'] = 'matching'

	for (key, value) in git.items():
		os.system('git config --global %s \"%s\"' % (key, value))

	return [dist.home + '/.gitconfig']
