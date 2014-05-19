#!/usr/bin/python

import sys

def process(a,b,c):
	per = 100 * a * b / c
	if per >= 100:
		per = 100

	print '%d%%\r' % per,
	sys.stdout.flush();
