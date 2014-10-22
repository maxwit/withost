import os
import shutil
import socket
from lib import base

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
			ip = get_ip(ifx)
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

def setup(dist, conf, apps):
	if not conf.has_key('net.domain'):
		raise Exception('domain name NOT configured!')
	doamin_name = conf['net.domain']

	#if conf.has_key('net.domain'):
	#	domain_name = conf['net.domain']
	#else:
	#	print 'Warning: domain name NOT configured! guessing ...'
	#	domain_name = socket.gethostname()
	#	tmp_dn = domain_name.split('.')
	#	if len(tmp_dn) < 3:
	#		raise Exception('Invalid domain name!')
	#	del tmp_dn[0]
	#	domain_name = '.'.join(tmp_dn)

	mail_server = 'mail.' + domain_name

	if conf.has_key('net.ip'):
		domain_addr = conf['net.ip']
	else:
		ifx = get_default_ifx()
		if ifx is None:
			raise Exception('Fail to find default NIC!')

		domain_addr = get_ip()

	forward = get_gateway(domain_addr)

	arpa_addr = domain_addr.split('.')[0:3]
	arpa_addr.reverse()
	arpa_addr = '.'.join(arpa_addr)

	zone_conf = '/etc/named.%s.zones' % domain_name
	pattern = {'__DOMAIN_NAME__':domain_name, '__DOMAIN_ADDR__':arpa_addr}
	base.render_to_file(zone_conf, 'dist/site/bind.zones', pattern)

	fd = open('/etc/named.conf')
	lines = fd.readlines()
	fd.close()

	for index in range(len(lines)):
		line = lines[index]
		if line.__contains__('listen'):
			lines[index] = line.replace('127.0.0.1', 'any')

		elif line.__contains__('allow-query'):
			lines[index] = line.replace('localhost', 'any')

		elif line.strip() == '};':
			lines.insert(index, '\n\tforwarders {\n\t\t%s;\n\t};\n' % forward.replace(' ', ';\n\t\t'))
			break

	lines.append('include "%s";\n' % zone_conf)
	open('/etc/named.conf', 'w').writelines(lines)

	arpa_conf = '/var/named/db.' + arpa_addr
	domain_conf = '/var/named/db.' + domain_name

	pattern['__EMAIL__'] = mail_server
	pattern['__ADDR__'] = domain_addr
	base.render_to_file(domain_conf, 'dist/site/bind-domain.conf', pattern)
	base.render_to_file(arpa_conf, 'dist/site/bind-arpa.conf', pattern)

	os.system('chmod +r /var/named/*')

def remove(dist, conf, apps):
	pass
