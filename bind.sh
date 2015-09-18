if [ -e /etc/redhat-release ]; then
	sudo yum install -y bind
	s=named
else
	sudo apt-get install -y bind9
	s=bind9
fi

sudo python << EOF
from app import bind
bind.setup(9, 18, {'net.domain':'maxwit.com'})
EOF

which systemctl > /dev/null
if [ $? -eq 0 ]; then
	sudo systemctl restart $s
else
	sudo service $s restart
fi

code=192.168.3.5

nsupdate << EOF
server 127.0.0.1
update add code.maxwit.com 3600 IN A $code
update add git.maxwit.com 3600 IN A $code
update add bug.maxwit.com 3600 IN A $code
update add ci.maxwit.com 3600 IN A $code
show
send
EOF

#grep 127.0.0.1 /etc/resolv.conf || sudo cp resolv.conf /etc/resolv.conf
