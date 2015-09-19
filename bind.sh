if [ $UID != 0 ]; then
	echo "must run as root!"
	exit 1
fi

ip='192.168.3.5'
domain='maxwit.com'

if [ -e /etc/redhat-release ]; then
	which named || yum install -y bind
	s=named
else
	which named || apt-get install -y bind9
	s=bind9
fi

python << EOF
from app import bind
bind.setup(9, 18, {'net.domain':'$domain'})
EOF

which systemctl > /dev/null
if [ $? -eq 0 ]; then
	systemctl enable $s || exit 1
	systemctl start $s || exit 1
else
	which chkconfig > /dev/null && chkconfig $s on || exit 1
	service $s start || exit 1
fi

nsupdate << EOF
server 127.0.0.1
update add code.$domain 3600 IN A $ip
update add git.$domain 3600 IN A $ip
update add bug.$domain 3600 IN A $ip
update add ci.$domain 3600 IN A $ip
show
send
EOF

if [ $? -ne 0 ]; then
	echo "fail to install bind!"
	exit 1
fi

echo "bind installed successfully!"
echo "pls insert 'nameserver 127.0.0.1' to /etc/resolv.conf if necessary for testing."
