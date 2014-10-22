import os
from lib import base

def setup(dist, conf, apps):
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
