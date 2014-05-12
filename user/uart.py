def config(dist, apps):
	rc = dist.home + '/.kermrc'
	dst = open(rc, 'w+')
	src = open('user/uart/kermrc')
	for line in src:
		dst.write(line)
	src.close()
	dst.close()

	return [rc]
