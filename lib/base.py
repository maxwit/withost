#!/usr/bin/python

import os
import re
import grp,pwd
import socket
import fcntl
import struct
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

def group_exist(group):
	for stru_gr in grp.getgrall():
		if group == stru_gr.gr_name:
			return True

	return False

def user_exist(user):
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

def get_ip(ifname):
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	local_ip = fcntl.ioctl(sock.fileno(), 0x8915, struct.pack('256s', ifname[:15]))
	return socket.inet_ntoa(local_ip[20:24])

def get_default_ifx():
	# FIXME
	for ifx in os.listdir('/sys/class/net'):
		if ifx == 'lo' or ifx.startswith('vmnet'):
			continue

		try:
			get_ip(ifx)
		except:
			# print 'interface "%s" is inactive, skipped.' % ifx
			continue

		return ifx

	return None

# FIXME
def get_gateway(ip):
	gw = ip.split('.')
	gw[3] = '253'
	return '.'.join(gw)
