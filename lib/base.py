#!/usr/bin/python

import sys

def process(a,b,c):
	per = 100 * a * b / c
	if per >= 100:
		per = 100

	print '%d%%\r' % per,
	sys.stdout.flush();

def name_to_mail(name):
	return name.lower().replace(' ', '.') + '@maxwit.com'

def get_full_name(user):
	fd_rept = open('/etc/passwd', 'r')

	for line in fd_rept:
		account = line.split(':')
		if account[0] == user:
			full_name = account[4].split(',')[0].strip()
			fd_rept.close()

			if full_name == '':
				return None
			return full_name

	fd_rept.close()
	raise Exception('User %s not found!' % user)

def group_exits(group):
	fp_group = open('/etc/group', 'r')

	for line in fp_group:
		group = line.split(':')[0]
		if group == group:
			fp_group.close()
			return True

	fp_group.close()

	return False

def user_exits(user):
	fp_user = open('/etc/passwd', 'r')

	for line in fp_user:
		account = line.split(':')
		if user == account[0]:
			fp_user.close()
			return True

	fp_user.close()

	return False
