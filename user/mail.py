#!/usr/bin/python

import os, sys
from datetime import date

def setup(dist, conf, apps):
	name = self.conf['name']
	# host = 'smtp.' + domain
	now = date.today()
	term = "cs%d%d" % (now.year % 100, (now.month + 1) / 2)

	if self.conf.has_key('email'):
		email = self.conf['email']
	else:
		email = self.name_to_mail(name)

	if self.conf.has_key('epass'):
		epass = self.conf['epass']
	else:
		epass = 'MW%s' % term

	domain = email.split('@')[1]

	maildir = 'Mail/Inbox/cur'
	if not os.path.exists(self.home + '/' + maildir):
		os.makedirs(self.home + '/' + maildir)

	for pkg in group:
		rc = '%s/.%src' % (self.home, pkg)

		if os.path.exists(rc):
			if not self.conf.has_key('email') and not self.conf.has_key('epass'):
				continue
			print 'updating %src ...' % pkg
		else:
			print 'generating %src ...' % pkg

		if pkg == 'msmtp':
			if os.path.exists(rc):
				for line in fileinput.input(rc, 1):
					s = line.split()
					if len(s) > 0 and (s[0] == 'user' or s[0] == 'from'):
						if self.conf.has_key('email'):
							print line.replace(s[1], email),
						else:
							print line,
					elif len(s) > 0 and (s[0] == 'password'):
						if self.conf.has_key('epass'):
							print line.replace(s[1], epass),
						else:
							print line,
					elif len(s) > 0 and (s[0] == 'host'):
						print line.replace(s[1], 'smtp.%s' % domain),
					else:
						print line,

				continue

			fd = open(rc, 'w+')
			fd.write('defaults\n\n')
			fd.write('account %s\n' % domain)
			fd.write('host smtp.%s\n' % domain)
			fd.write('user %s\n' % email)
			fd.write('from %s\n' % email)
			fd.write('password %s\n' % epass)
			fd.write('auth login\n\n')
			fd.write('account default: %s' % domain)
			fd.close()
		elif pkg == 'fetchmail':
			if os.path.exists(rc):
				for line in fileinput.input(rc, 1):
					s = line.split()
					if len(s) > 0 and (s[0] == 'user'):
						if self.conf.has_key('email'):
							print line.replace(s[1], email),
						else:
							print line,
					elif len(s) > 0 and (s[0] == 'poll'):
						if self.conf.has_key('email'):
							print line.replace(s[1], 'pop.%s' % domain),
						else:
							print line,
					elif len(s) > 0 and (s[0] == 'password'):
						if self.conf.has_key('epass'):
							print line.replace(s[1], epass),
						else:
							print line,
					else:
						print line,

				continue

			fd = open(rc, 'w+')
			fd.write('set daemon 600\n')
			fd.write('poll pop.%s with protocol pop3\n' % domain)
			fd.write('uidl\n')
			fd.write('user "%s"\n' % email)
			fd.write('password "%s"\n' % epass)
			fd.write('keep\n')
			fd.write('mda "/usr/bin/procmail -d %T"\n')
			fd.close()
		elif pkg == 'procmail':
			if os.path.exists(rc):
				continue

			fd = open(rc, 'w+')
			fd.write('MAILDIR=$HOME/Mail\n')
			fd.write('DEFAULT=$MAILDIR/Inbox/\n')
			fd.close()

		os.chmod(rc, 0600)
