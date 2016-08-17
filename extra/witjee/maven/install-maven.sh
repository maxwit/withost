#!/bin/sh

dst_dir=/opt/maven
profile=/etc/profile.d/maven.sh
maven_list=()

if [ -z $WITPUB ]; then
	for path in /opt/witpub /mnt/witpub
	do
		if [ -e $path ]; then
			WITPUB=$path
			break
		fi
	done

	if [ -z $WITPUB ]; then
		echo "WITPUB not set!"
		exit 1
	fi
fi

function usage
{
	echo "usage: `basename $0` [-d <dir>] <maven list>"
}

#function remove_maven
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
		maven_list=($@)
		;;
	esac

	shift
done

if [ ${#maven_list[@]} -eq 0 ]; then
	maven_list=(`ls $WITPUB/devel/java/maven/apache-maven-*-bin.tar.gz 2>/dev/null`)
	if [ ${#maven_list[@]} -eq 0 ]; then
		echo -e "no maven found!\n"
		exit 1
	fi
fi

if [ -e $dst_dir ]; then
	echo "'$dst_dir' already exists!"
	exit 1
fi

mkdir -p $dst_dir || exit 1
maven_home=$dst_dir/current

cd $dst_dir
for maven in ${maven_list[@]}
do
	echo "Extracting $maven to '$PWD' ..."
	case $maven in
	*.tar.*)
		tar xf $maven || exit 1
		;;
	*.bin)
		$maven > /dev/null || exit 1
		;;
	esac
done
echo

priority=1
update-alternatives --force --remove-all maven
for alt in `ls -d $dst_dir/*`
do
	if [ -d $alt ]; then
		update-alternatives --install $maven_home maven $alt $((priority))00
		((priority++))
	fi
done
echo

cat > $profile << EOF
export MAVEN_HOME=$maven_home
export PATH=\$MAVEN_HOME/bin:\$PATH
EOF

#source $profile
#mvn -version
#if [ $? -eq 0 ]; then
#	echo "JDK installed successfully!"
#else
#	update-alternatives --remove-all --force maven
#	rm -rf $dst_dir
#	echo "JDK failed to install!"
#fi
echo
