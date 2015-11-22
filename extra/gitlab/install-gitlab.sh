#!/bin/sh

sudo yum install -y curl openssh-server postfix cronie
sudo service postfix start
sudo chkconfig postfix on
sudo lokkit -s http -s ssh

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
sudo yum install -y --force-yes gitlab-ce

sudo gitlab-ctl reconfigure
