import os
from lib import base

conf = {'net.domain':'maxwit.com'}

def setup(dist, apps):
	if not conf.has_key('net.domain'):
		raise Exception('domain name NOT configured!')
	domain_name = conf['net.domain']

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
		ifx = base.get_default_ifx()
		if ifx is None:
			raise Exception('Fail to find default NIC!')

		domain_addr = base.get_ip(ifx)

	forward = base.get_gateway(domain_addr)

	arpa_addr = domain_addr.split('.')[0:3]
	arpa_addr.reverse()
	arpa_addr = '.'.join(arpa_addr)

	zone_conf = '/etc/named.%s.zones' % domain_name
	domain_conf = '/var/named/db.' + domain_name
	arpa_conf = '/var/named/db.' + arpa_addr

	pattern = { '__DOMAINNAME__':domain_name, '__MAILSERVER__':mail_server,
				'__DOMAINADDR__':domain_addr, '__ARPAADDR__':arpa_addr }

	base.render_to_file(zone_conf, 'app/bind/bind.zones', pattern)
	base.render_to_file(domain_conf, 'app/bind/bind-domain.conf', pattern)
	base.render_to_file(arpa_conf, 'app/bind/bind-arpa.conf', pattern)

	fd = open('/etc/named.conf')
	lines = fd.readlines()
	fd.close()

	for index in range(len(lines)):
		line = lines[index]
		if 'listen' in line:
			lines[index] = line.replace('127.0.0.1', 'any')

		elif 'allow-query' in line:
			lines[index] = line.replace('localhost', 'any')

		elif line.strip() == '};':
			lines.insert(index, '\n\tforwarders {\n\t\t%s;\n\t};\n' % forward.replace(' ', ';\n\t\t'))
			break

	lines.insert(-1, 'include "%s";\n' % zone_conf)
	open('/etc/named.conf', 'w').writelines(lines)

	os.system('chmod +r /var/named/*')

def remove(dist, conf, apps):
	pass
