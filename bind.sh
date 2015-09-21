if [ $UID != 0 ]; then
	echo "must run as root!"
	exit 1
fi

domain='maxwit.com'
repo='192.168.3.3'
code='192.168.3.5'

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

function add_ns
{
dn=$1.$domain
rip=`echo $2 | awk -F '.' '{print $4"."$3"."$2"."$1}'`

nsupdate << EOF
server 127.0.0.1
update add ${dn} 3600 IN A $2
show
send
update add ${rip}.in-addr.arpa 3600 IN PTR ${dn}
show
send
EOF
}

add_ns repo  $repo

add_ns code  $code
add_ns git   $code
add_ns issue $code
add_ns ci    $code

if [ $? -ne 0 ]; then
	echo "fail to install bind!"
	exit 1
fi

echo "bind installed successfully!"
echo "pls insert 'nameserver 127.0.0.1' to /etc/resolv.conf if necessary for testing."
