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

if [ -e /etc/redhat-release ]; then
	installer="yum install -y"
	$installer curl openssh-server postfix cronie
	service postfix start
	chkconfig postfix on
	lokkit -s http -s ssh
	curl -sS https://packages.gitlab.com/install/repositories/gitlab/$edition/script.rpm.sh | bash
elif [ -e /etc/debian_version ]; then
	installer="apt install -y"
	$installer curl openssh-server ca-certificates postfix
	curl -sS https://packages.gitlab.com/install/repositories/gitlab/$edition/script.deb.sh | bash
else
	exit 1
fi

err=0
for ((i=0; i<5; i++))
do
	$installer $edition
	err=$?
	[ $err -eq 0 ] && break
done
[ $err -ne 0 ] && exit 1

sed -i -e "s#external_url .*#external_url 'http://code.maxwit.com'#" \
	-e "s/# gitlab_rails\['gitlab_email_from'\] =.*/gitlab_rails['gitlab_email_from'] = 'no-reply@maxwit.com'/" \
	-e "s/# gitlab_rails\['gitlab_email_display_name'\] =.*/gitlab_rails['gitlab_email_display_name'] = 'MaxWit SCM'/" \
	-e "s/# gitlab_rails\['smtp_enable'\] =.*/gitlab_rails['smtp_enable'] = true/" \
	-e "s/# gitlab_rails\['smtp_address'\] =.*/gitlab_rails['smtp_address'] = 'smtp.exmail.qq.com'/" \
	-e "s/# gitlab_rails\['smtp_port'\] =.*/gitlab_rails['smtp_port'] = 465 /" \
	-e "s/# gitlab_rails\['smtp_user_name'\] =.*/gitlab_rails['smtp_user_name'] = 'no-reply@maxwit.com'/" \
	-e "s/# gitlab_rails\['smtp_password'\] =.*/gitlab_rails['smtp_password'] = 'maxwit2015'/" \
	-e "s/# gitlab_rails\['smtp_domain'\] =.*/gitlab_rails['smtp_domain'] = 'maxwit.com'/" \
	-e "s/# gitlab_rails\['smtp_authentication'\] =.*/gitlab_rails['smtp_authentication'] = 'login'/" \
	-e "s/# gitlab_rails\['smtp_enable_starttls_auto'\] =.*/gitlab_rails['smtp_enable_starttls_auto'] = true/" \
	-e "s/# gitlab_rails\['smtp_tls'\] =.*/gitlab_rails['smtp_tls'] = true/" \
	/etc/gitlab/gitlab.rb

gitlab-ctl reconfigure
