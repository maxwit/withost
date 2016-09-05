#!/bin/bash

mkdir -pv /share/smb 2> /dev/null
yum -y install samba 2> /dev/null
service smb start 2> /dev/null
service nmb start 2> /dev/null
while [ $? -eq 0 ]; do
	cp /etc/samba//smb.conf{,.bak}
	cat >> /etc/samba/smb.conf << EOF
	[shared]
		comment = hinimix shared folder
		path = /share/smb
		writable = yes
		browseable = yes
		guest ok = no
EOF
	break
done
sed -i "s/workgroup = MYGROUP/workgroup = WORKGROUP/" /etc/samba/smb.conf

service smb restart 2> /dev/null
service nmb restart 2> /dev/null


while read line
do
	record=($line)
	user=${record[2]%%.*}
	setfacl -m u:$user:rwx /share/smb
	smbpasswd -a $user << EOF
Inspiry123
Inspiry123
EOF
done < $1
