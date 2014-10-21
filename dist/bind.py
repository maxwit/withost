import os
import shutil
from lib import base

def setup(dist, conf, apps):
	forward      = '192.168.3.253'
	domain_name  = 'maxwit.org'
	domain_addr  = '192.168.3.253'
	domain_email = 'email.maxwit.org'

	addr_arpa = domain_addr.split('.')[0:3]
	addr_arpa.reverse()
	addr_arpa = '.'.join(addr_arpa)
	addr_arpa_file = 'db.%s' % addr_arpa
	domain_file = 'db.%s' % domain_name

	zone_conf = '/etc/named.%s.zones' % domain_name
	pattern = {'__DOMAIN_NAME__':domain_name, '__DOMAIN_ADDR__':addr_arpa}
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

	domain_conf = '/var/named/%s' % domain_file
	addr_arpa_conf = '/var/named/%s' % addr_arpa_file

	pattern = {'__EMAIL__':domain_email, '__ADDR__':domain_addr}
	base.render_to_file(domain_conf, 'dist/site/bind-domain.conf', pattern)

	pattern = {'__EMAIL__':domain_email, '__NAME__':domain_name}
	base.render_to_file(addr_arpa_conf, 'dist/site/bind-arpa.conf', pattern)

	os.system('chmod +r /var/named/*')

def remove(dist, conf, apps):
	pass
