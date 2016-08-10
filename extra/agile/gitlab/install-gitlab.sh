#!/bin/sh

edition="gitlab-ce"

if [ $UID -ne 0 ]; then
	echo "must run as root!"
	exit 1
fi

#if [ $# -eq 1 ]; then
#	port=$1
#else
#	port=10080
#fi

#if [ -e /etc/redhat-release ]; then
#	installer="yum install -y"
#	which systemctl > /dev/null && {
#		$installer curl policycoreutils openssh-server openssh-clients
#		systemctl enable sshd
#		systemctl start sshd
#		yum install postfix
#		systemctl enable postfix
#		systemctl start postfix
#		firewall-cmd --permanent --add-service=http
#		systemctl reload firewalld
#	} || {
#		$installer curl openssh-server postfix cronie
#		service postfix start
#		chkconfig postfix on
#		lokkit -s http -s ssh
#	}
#	curl -sS https://packages.gitlab.com/install/repositories/gitlab/$edition/script.rpm.sh | bash
#else
#	installer="apt-get install -y"
#	$installer curl openssh-server ca-certificates postfix
#	curl -sS https://packages.gitlab.com/install/repositories/gitlab/$edition/script.deb.sh | bash
#fi
#
#err=0
#for ((i=0; i<5; i++))
#do
#	$installer $edition
#	err=$?
#	[ $err -eq 0 ] && break
#done
#[ $err -ne 0 ] && exit 1

if [ $edition != gitlab-ce ]; then
	echo "only CE supported!"
	exit 1
fi

if [ -e /etc/redhat-release ]; then
	installer="yum install -y"

	$installer redhat-lsb-core
	release=`lsb_release -rs`
	release=(${release//./ })

	if [ ! -e /etc/yum.repos.d/$edition.repo ]; then
		cat > /etc/yum.repos.d/$edition.repo << _EOF_
[$edition]
name=$edition
baseurl=http://mirrors.tuna.tsinghua.edu.cn/$edition/yum/el${release[0]}
repo_gpgcheck=0
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
_EOF_
		yum makecache
	fi
else
	#installer="apt-get install -y"
	installer="apt-get install -y --allow-unauthenticated"

	curl https://packages.gitlab.com/gpg.key 2> /dev/null | sudo apt-key add -

	if [ ! -e /etc/apt/sources.list.d/$edition.list ]; then
		code=`lsb_release -cs`
		echo "deb https://mirrors.tuna.tsinghua.edu.cn/$edition/ubuntu $code main" > /etc/apt/sources.list.d/$edition.list
		apt-get update
	fi
fi

if [ ! -d /opt/$edition ]; then
	$installer $edition || exit 1
fi

sed -i -e "s#external_url .*#external_url 'http://code.maxwit.com'#" \
	-e "s/# gitlab_rails\['gitlab_email_from'\] =.*/gitlab_rails['gitlab_email_from'] = 'no-reply@maxwit.com'/" \
	-e "s/# gitlab_rails\['gitlab_email_display_name'\] =.*/gitlab_rails['gitlab_email_display_name'] = 'MaxWit SCM'/" \
	-e "s/# gitlab_rails\['smtp_enable'\] =.*/gitlab_rails['smtp_enable'] = true/" \
	-e "s/# gitlab_rails\['smtp_address'\] =.*/gitlab_rails['smtp_address'] = 'smtp.exmail.qq.com'/" \
	-e "s/# gitlab_rails\['smtp_port'\] =.*/gitlab_rails['smtp_port'] = 465 /" \
	-e "s/# gitlab_rails\['smtp_user_name'\] =.*/gitlab_rails['smtp_user_name'] = 'no-reply@maxwit.com'/" \
	-e "s/# gitlab_rails\['smtp_password'\] =.*/gitlab_rails['smtp_password'] = 'MaxWit2016'/" \
	-e "s/# gitlab_rails\['smtp_domain'\] =.*/gitlab_rails['smtp_domain'] = 'maxwit.com'/" \
	-e "s/# gitlab_rails\['smtp_authentication'\] =.*/gitlab_rails['smtp_authentication'] = 'login'/" \
	-e "s/# gitlab_rails\['smtp_enable_starttls_auto'\] =.*/gitlab_rails['smtp_enable_starttls_auto'] = true/" \
	-e "s/# gitlab_rails\['smtp_tls'\] =.*/gitlab_rails['smtp_tls'] = true/" \
	/etc/gitlab/gitlab.rb

gitlab-ctl reconfigure
