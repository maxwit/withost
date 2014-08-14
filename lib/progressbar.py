#!/usr/bin/python

import time
import sys

def set_progressbar(value, max = 100, min = 0):
	if value < min or value > max:
		print 'error value'
		exit()

	cur = float(50) / (max - min) * (value - min)
	show(value, cur)

def show(value, cur):
	sys.stdout.write('\r' + str(value) + '%[')

	for x in range(1, 51):
		if x < cur:
			sys.stdout.write('=')
		elif x == cur:
			sys.stdout.write('>')
		else:
			sys.stdout.write(' ')

	sys.stdout.write(']')
	sys.stdout.flush()
