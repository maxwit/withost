#!/usr/bin/python

import os
from argparse import ArgumentParser
from dist import website

if __name__ == '__main__':
	if os.getuid() != 0:
		print 'pls run as root or with sudo!'
		exit()

	opt_parser = ArgumentParser(description='Add site or delete site')
	opt_parser.add_argument('operation', action='store',
						choices=('add','del'), help='add or delete a site')
	opt_parser.add_argument('-t', '--type', action='store',
						dest='type', help='server type')
	opt_parser.add_argument('-b', '--back', action='store',
						dest='back', help='backend')
	opt_parser.add_argument('-o', '--owner', action='store',
						dest='owner', help='site owner')
	opt_parser.add_argument('server_name', action='store',
						help='server name')
	args = opt_parser.parse_args()

	if args.type:
		server_type = args.type
	else:
		server_type = 'nginx'

	if args.back:
		backend = args.back
	else:
		backend = None

	if args.operation == 'add':
		owner = args.owner or os.getlogin()
		website.add_site(('Fedora',), server_type, args.server_name, owner, backend)
	else: #if args.operation == 'del':
		website.del_site(('Fedora',), server_type, args.server_name)

	print
