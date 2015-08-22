#!/usr/bin/env python

import sys, urlparse

try:
	base_dir = sys.argv[1]
	r = urlparse.urlparse(base_dir)

	if r.scheme in ['http', 'https'] :
		if r.netloc.find(':') != -1 :
			host, port = r.netloc.split(':')
		else :
			host = r.netloc
			if r.scheme == 'http' :
				port = '80'
			else :
				port = '443'

		print 'export BASE_URL_SCHEME=%s' % r.scheme
		print 'export BASE_URL_HOST=%s' % host
		print 'export BASE_URL_PORT=%s' % port

except:
	pass
