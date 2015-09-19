import os
from lib import base

def setup(dist, apps, conf):
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

	named_path = None
	for dir in ['/etc', '/etc/bind']:
		if os.path.exists(dir + '/named.conf'):
			named_path = dir
	if named_path is None:
		raise Exception('named.conf not found!')

	named_conf = named_path + '/named.conf'
	zone_conf  = named_path + '/named.%s.zones' % domain_name
	# rndc_key   = named_path + '/rndc.key'

	# FIXME: detect by options.directory
	directory = None
	for dir in ['/var/named', '/var/cache/bind']:
		if os.path.isdir(dir):
			directory = dir
	if directory is None:
		raise Exception('DB directory not found!')

	domain_conf = directory + '/db.' + domain_name
	arpa_conf = directory + '/db.' + arpa_addr

	pattern = { '__DOMAINNAME__':domain_name, '__MAILSERVER__':mail_server,
				'__DOMAINADDR__':domain_addr, '__ARPAADDR__':arpa_addr }

	base.render_to_file(zone_conf, 'app/bind/bind.zones', pattern)
	base.render_to_file(domain_conf, 'app/bind/bind-domain.conf', pattern)
	base.render_to_file(arpa_conf, 'app/bind/bind-arpa.conf', pattern)

	os.system('chmod g+w ' + directory) # FIXME
	os.system('chmod +r %s/*' % directory)

	fd = open(named_conf)
	lines = fd.readlines()
	fd.close()

	in_options = False
	for index in range(len(lines)):
		line = lines[index].replace('\n', '')
		if line == 'options {':
			in_options = True
		elif 'listen-on' in line:
			lines[index] = line.replace('127.0.0.1', 'any')
		elif 'allow-query' in line:
			lines[index] = line.replace('localhost', 'any')
		elif line == '};' and in_options:
			lines.insert(index, '\n\tforwarders {\n\t\t%s;\n\t};\n' % forward.replace(' ', ';\n\t\t'))
			in_options = False
		elif zone_conf in line:
			print "domain '%s' updated!" % domain_name
			return

	lines.append('include "%s";\n' % zone_conf)
	# lines.append('include "%s";\n' % rndc_key)
	open(named_conf, 'w').writelines(lines)

	print "DNS for domain '%s' configured!" % domain_name

def remove(dist, apps, conf):
	pass
