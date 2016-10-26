#!/bin/bash

while [ $# -gt 0 ]
do
	case $1 in
	-m|--master)
		master=$2
		shift
		;;
	-s|--slaves)
		slaves=(${2//,/ })
		shift
		;;
	-d|--database)
		db=$2
		shift
		;;
	*)
		echo "Invalid option '$1'"
		echo "Usage: $0 [options]"
		echo
		exit 1
		;;
	esac

	shift
done

echo ${#slaves[@]}
