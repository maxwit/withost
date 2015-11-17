#!/bin/sh

function usage
{
	echo "usage: `basename $0` [-d <dir>] <jdk>"
}

function get_version
{
	ver=(`basename ${versions[$1]} | awk -F'-' '{print $2}' | awk -F'u' '{print $1}'`)
	echo $ver
}

if [ $UID != 0 ]; then
	dst_dir=$HOME
	if [ -e /etc/redhat-release ]; then
		profile=$HOME/.bash_profile
	else
		profile=$HOME/.profile
	fi
else
	dst_dir=/opt
	profile=/etc/profile
fi

while [ $# -gt 0 ]
do
	case $1 in
	-d|--dir)
		dst_dir=$2
		shift
		;;
	-*)
		echo -e "Invalid option '$'\n"
		exit 1
		;;
	*)
		if [ -n "$jdk_tar" ]; then
			usage
			exit 1
		fi
		jdk_tar=$1
		;;
	esac

	shift
done

if [ -z "$jdk_tar" ]; then
	versions=(`ls /mnt/witpub/devel/java/jdk/jdk-*-linux-*.tar.* 2>/dev/null`)

	s=${#versions[@]}
	if [ $s -eq 0 ]; then
		usage
		exit 1
	fi

	m=0
	ver_m=`get_version 0`

	for ((i=1; i<$s; i++))
	do
		ver_c=`get_version $i`

		if [ $ver_c -gt $ver_m ]; then
			m=$i
		fi
	done

	jdk_tar=${versions[$m]}
elif [ ! -e "$jdk_tar" ]; then
	echo -e "'$jdk_tar' does NOT exist!\n"
	exit 1
fi

jdk_ver=`tar -tf $jdk_tar | head -n 1`
JAVA_HOME=$dst_dir/${jdk_ver%%/*}

echo -n "Installing JDK ."
count=0
tar xvf $jdk_tar -C $dst_dir | while read line
do
	((count++))
	if [ $((count % 50)) -eq 0 ]; then
		 echo -n .
	fi
done || exit 1
echo " Done."

temp=`mktemp`
cat > $temp << EOF
export JAVA_HOME=$JAVA_HOME
export CLASS_PATH=.:\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

while read line
do
	eval $line
done < $temp

javac -version
if [ $? -eq 0 ]; then
	sed -i '/JAVA_HOME/d' $profile
	cat $temp >> $profile
	rm $temp
	echo "JAVA_HOME = $JAVA_HOME"
	echo "JDK installed successfully!"
else
	rm -rf $JAVA_HOME
	echo "JDK failed to install!"
fi
