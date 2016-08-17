#!/bin/sh

dst_dir=/opt/jdk
profile=/etc/profile.d/jdk.sh
jdk_list=()

function usage
{
	echo "usage: `basename $0` [-d <dir>] <jdk list>"
}

#function remove_jdk
#{
#}

if [ $UID != 0 ]; then
	echo "pls run as root!"
	exit 1
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
		jdk_list=($@)
		break #?
		;;
	esac

	shift
done

if [ ${#jdk_list[@]} -eq 0 ]; then
	##if [ `uname -m` = 'x86_64' ]; then
	##	arch=x64
	##else
	##	arch=i386
	##fi

	#if [ -z $WITPUB ]; then
	#	for path in /opt/witpub /mnt/witpub
	#	do
	#		if [ -e $path ]; then
	#			WITPUB=$path
	#			break
	#		fi
	#	done
	#
	#	if [ -z $WITPUB ]; then
	#		echo "WITPUB not set!"
	#		exit 1
	#	fi
	#fi

	#bin_list=`ls $WITPUB/devel/java/jdk/jdk-*-linux-*.tar.* 2>/dev/null`
	#tar_list=`ls $WITPUB/devel/java/jdk/jdk-*-linux-*.bin 2>/dev/null`

	#jdk_list=($bin_list $tar_list)
	#if [ ${#jdk_list[@]} -eq 0 ]; then
		echo -e "No JDK found!"
		usage
		exit 1
	#fi
fi

#if [ -e $dst_dir ]; then
#	echo "'$dst_dir' already exists!"
#	exit 1
#fi

mkdir -p $dst_dir || exit 1

cd $dst_dir
for jdk in ${jdk_list[@]}
do
	echo "Extracting $jdk to '$PWD' ..."
	case $jdk in
	*.tar|*.tar.*)
		tar xf $jdk || exit 1
		;;
	*.bin)
		$jdk > /dev/null || exit 1
		;;
	*)
		echo "'$jdk' file format not supported!"
		exit 1
	esac
done
echo

priority=2
for jdk_home in `ls -d $dst_dir/*`
do
	if [ -d $jdk_home ]; then
		for bin in $jdk_home/jre/bin $jdk_home/bin
		do
			for alt in `ls $bin`
			do
				if [ -L $bin/$alt -o $bin/$alt = $jdk_home/bin/java -o $alt = apt ]; then
					echo "skipping '$bin/$alt'"
					continue
				else
					update-alternatives --install /usr/bin/$alt $alt $bin/$alt $((priority))000
				fi
			done
		done
		java_home=$jdk_home
		((priority++))
		echo
	fi
done
echo

cat > $profile << EOF
export JAVA_HOME=$java_home
export CLASS_PATH=.:\$JAVA_HOME/lib:\$JAVA_HOME/jre/lib
#export PATH=\$JAVA_HOME/bin:\$PATH
EOF

#while read line
#do
#	eval $line
#done < $profile

#source $profile
javac -version
if [ $? -eq 0 ]; then
	echo "JDK installed successfully!"
else
	#update-alternatives --remove-all --force jdk
	rm -rf $dst_dir
	echo "JDK failed to install!"
fi
echo
