import os
import urllib
from lib import base

def setup(dist, conf, apps):
	shutil.copyfile('dist/tomcat.conf', '/etc/nginx/conf.d/')
	os.system('ln -s /etc/nginx/site-enabled/default /etc/nginx/site-available/tomcat.conf')
	os.system("service nginx restart")
