import platform

def get_dist():
	os_type = platform.system()

	if os_type == 'Linux':
		dist_name = platform.dist()[0]

		version = platform.dist()[1]
		ver = version.split('.')
		if len(ver) > 2:
			version = '%s.%s' % (ver[0], ver[1])

		if dist_name in ['Debain', 'Ubuntu', 'Mint']:
			from debian import debian
			dist = debian((dist_name, version))
		elif dist_name in ['redhat', 'fedora', 'centos', 'OLinux']:
			from redhat import redhat
			dist = redhat((dist_name, version))
		else:
			raise Exception(dist_name + ' NOT supported!')
	elif os_type == 'Darwin':
		from osx import osx

		dist_name = 'OS X'
		version = platform.mac_ver()[0]
		dist = osx((ditrib, version))
	else:
		if os_type == 'Windows':
			version = platform.win32_ver()[0]
			os_type = os_type + ' ' + version

		raise Exception(os_type + ' NOT supported!')

	return dist
