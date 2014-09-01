#!/usr/bin/python

import sys
import re
import grp,pwd
import progressbar

def process(a, b, c):
	per = 100 * a * b / c
	if per >= 100:
		per = 100

	progressbar.set_value(per)

def name_to_mail(name):
	return name.lower().replace(' ', '.') + '@maxwit.com'

def get_full_name(user):
	try:
		full_name = pwd.getpwnam(user).pw_gecos.split(',')[0].strip()

		if full_name == '':
			return None
		return full_name

	except KeyError:
		raise Exception('User %s not found!' % user)

def group_exits(group):
	for stru_gr in grp.getgrall():
		if group == stru_gr.gr_name:
			return True

	return False

def user_exits(user):
	for stru_passwd in pwd.getpwall():
            if user == stru_passwd.pw_name:
			return True

	return False

def multiple_replace(text, sdict):
	rx = re.compile('|'.join(map(re.escape, sdict)))
	def one_xlat(match):
		return sdict[match.group(0)]
	return rx.sub(one_xlat, text)

def render_to_file(dst, src, pattern):
	fsrc = open(src)
	fdst = open(dst, 'w+')
	for line in fsrc:
		line = multiple_replace(line, pattern)
		fdst.write(line)
	fsrc.close()
	fdst.close()
