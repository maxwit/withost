#!/bin/sh

if [ $UID -eq 0 ]; then
	echo "do NOT run as root!"
	exit 1
fi

tomcat_user=$USER
port_base=8

while [ $# -gt 0 ]
do
	case $1 in
	-t|--tomcat-home)
		tomcat_home=${2%/}
		shift
		;;
#	-l|--url-path)
#		url_path=$2
#		shift
#		;;
#	-u|--tomcat_user)
#		tomcat_user=$2
#		shift
#		;;
	-p|--port-base)
		port_base=$2
		shift
		;;
#	-w|--war)
#		war=$2
#		shift
#		;;
	*)
		echo -e "Invalid option '$1'\n"
		exit 1
		;;
	esac

	shift
done

#tar xf $pkg -C /opt || exit 1
#mkdir -p /opt/share
#useradd -m -d /opt/share/tomcat tomcat
#chown -R tomcat.tomcat -R $tomcat_home

if [ ! -x $tomcat_home/bin/catalina.sh ]; then
	echo "invalid tomcat home '$tomcat_home'!"
	exit 1
fi

if [ ${#port_base} -gt 2 ]; then
	echo "invalid port base '$port_base'!"
	exit 1
fi

sed -i "s/port=\"8/port=\"$port_base/g" $tomcat_home/conf/server.xml

temp=`mktemp`

cat > $temp << EOF
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="admin" password="maxwit" roles="manager-gui,manager-script,manager-jmx,manager-status"/>
EOF
sed -i "/<tomcat-users>/r $temp" $tomcat_home/conf/tomcat-users.xml

cat > $temp << EOF
#!/bin/sh

case \$1 in
start)
	sudo -i -u $tomcat_user $tomcat_home/bin/catalina.sh start
	;;
stop)
	sudo -i -u $tomcat_user $tomcat_home/bin/catalina.sh stop
	;;
restart)
	sudo -i -u $tomcat_user $tomcat_home/bin/catalina.sh stop
	sudo -i -u $tomcat_user $tomcat_home/bin/catalina.sh start
	;;
*)
	echo "usage: xxx"
	;;
esac
EOF

service=`basename $tomcat_home`
sudo install -m 755 $temp /etc/init.d/$service

rm $temp

echo -e "$tomcat_home configured!\n\tport = ${port_base}080\n\tuser = $tomcat_user\n\tservice = $service\n"
