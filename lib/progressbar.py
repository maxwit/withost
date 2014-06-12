#!/usr/bin/python

import time
import sys

class Pro:
	def __init__(self):
		self.value = 0
		self.cur = 0
		self.max = 100
		self.min = 0

	def set_range(self, min, max):
		self.min = min
		self.max = max

	def set_value(self, value):
		if value < self.min or value > self.max:
			print 'error value'
			exit()

		self.value = value
		self.cur = float(50) / (self.max - self.min) * (value - self.min)
		self.show()

	def show(self):
		sys.stdout.write('\r' + str(self.value) + '%[')

		for x in range(1, 51):
			if x < self.cur:
				sys.stdout.write('=')
			elif x == self.cur:
				sys.stdout.write('>')
			else:
				sys.stdout.write(' ')

		sys.stdout.write(']')
		sys.stdout.flush()

if __name__ == '__main__':
	print "test"
