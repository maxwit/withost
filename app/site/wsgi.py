def application(environ, start_response): 
	start_response('200 OK', [('Content-type', 'text/html')])
	return ['<br/><center>Hello from <b>__SERVERNAME__</b>!</center>']
