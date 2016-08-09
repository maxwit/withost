#!/bin/sh

#. ./env.ini

if [ $# -ne 1 ]; then
	echo "Usage: $0 <env>"
	exit 1
fi

env=$1

# FIXME
dm_url=`grep ^${env}_dm= env.ini | awk -F'=' '{print $2}'`
dm1_url=`grep ^${env}_dm1= env.ini | awk -F'=' '{print $2}'`
dm2_url=`grep ^${env}_dm2= env.ini | awk -F'=' '{print $2}'`

for x in dm dm1 dm2
do
	echo ${x}_url
done
