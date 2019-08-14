#!/usr/bin/env bash

# function pip_safe_install
# {
#     while [ true ]; do
#         pip install -U $@ && break
#     done
# }

if [ $UID == 0 ]; then
    echo "do NOT run as root!"
    exit 1
fi

# FIXME
kolla_mode='pip' # or git

openstack_release=${openstack_release:-stein}

# FIXME
ifx=(`ip a | grep -owe "\s[ew][0-9a-zA-Z]\+:" | sed 's/://g'`)
if [ ${#ifx[@]} == 0 ]; then
  echo "no NIC found!"
  exit 1
fi

network_interface="${ifx[0]}"
if [ ${#ifx[@]} == 1 ]; then
  neutron_external_interface="${ifx[0]}"
else
  neutron_external_interface="${ifx[1]}"
fi

if [ -z "$kolla_internal_vip_address" ]; then
    ip0=`ip a s dev $network_interface | grep -e "inet\s.*brd" | awk '{print $2}' | awk -F '/' '{print $1}'`
    kolla_internal_vip_address=${ip0%.*}.111
fi

if [ -e /etc/os-release ]; then
    . /etc/os-release
    os_type=$ID
    os_name=$NAME
    os_version=$VERSION_ID # maybe none on ArchLinux
elif [ -e /etc/redhat-release ]; then
    dist=(`head -n 1 /etc/redhat-release`)
    os_type=`tr A-Z a-z <<< ${dist[0]}`
    os_name=${dist[0]}
    os_version=${dist[2]}
else
    echo -e "Unkown Linux distribution!\n"
    exit 1
fi

case "$os_type" in
centos)
    sudo yum install -y epel-release && \
    sudo yum install -y python-pip python-devel libffi-devel gcc git openssl-devel libselinux-python python-virtualenv || exit 1
    ;;
ubuntu)
    sudo apt install -y python-pip python-dev libffi-dev gcc git libssl-dev python-selinux python-virtualenv || exit 1
    ;;
*)
    echo "unknown linux distribution '$os_type'!"
    exit 1
esac

ENVPATH=$HOME/envs/envos

virtualenv $ENVPATH
source $ENVPATH/bin/activate

for p in pip ansible kolla-ansible python-openstackclient; do
	pip install -U $p
done

if [ "$kolla_mode" == 'pip' ]; then
    kolla_home=$ENVPATH/share/kolla-ansible
    sudo rm -rf /etc/kolla
    sudo cp -r $kolla_home/etc_examples/kolla /etc/
    sudo chown -R $USER.$USER /etc/kolla
    kolla-genpwd
    # grep 'BEGIN PRIVATE KEY' /etc/kolla/passwords.yml > /dev/null || kolla-genpwd || exit 1
else
    for repo in kolla kolla-ansible; do
        if [ ! -d $repo ]; then
            git clone https://github.com/openstack/$repo || exit 1
        fi
    done
    kolla_home=$PWD/kolla-ansible
    export PATH=$kolla_home/tools:$PATH
    [ -d /etc/kolla ] || cp -r $kolla_home/etc/kolla /etc/kolla || exit 1
    grep 'BEGIN PRIVATE KEY' /etc/kolla/passwords.yml > /dev/null || generate_passwords.py || exit 1
fi

sudo mkdir -p /etc/ansible
sudo tee /etc/ansible/ansible.cfg <<- 'EOF'
[defaults]
host_key_checking=False
pipelining=True
forks=100
EOF

sed -i -e "s/^#*\s*\(network_interface:\).*/\1 \"$network_interface\"/" \
    -e "s/^#*\s*\(neutron_external_interface:\).*/\1 \"$neutron_external_interface\"/" \
    -e "s/^#*\s*\(kolla_internal_vip_address:\).*/\1 \"$kolla_internal_vip_address\"/" \
    -e "s/^#*\s*\(openstack_release:\).*/\1 \"$openstack_release\"/" \
    -e "s/^#*\s*\(kolla_base_distro:\).*/\1 \"$os_type\"/" \
    -e "s/^#*\s*\(kolla_install_type:\).*/\1 \"source\"/" \
    /etc/kolla/globals.yml

# FIXME: add multinode support
inventory=$kolla_home/ansible/inventory/all-in-one

for task in bootstrap-servers prechecks deploy; do
    kolla-ansible -i $inventory $task
    # FIXME: add exception handler here
done

kolla-ansible post-deploy

grep -q OpenStack ~/.bashrc || cat >> ~/.bashrc << EOF
# OpenStack
source $ENVPATH/bin/activate
. /etc/kolla/admin-openrc.sh
EOF

source ~/.bashrc
$kolla_home/init-runonce

# cat > /etc/systemd/system/docker.service.d/kolla.conf << _EOF_
# [Service]
# MountFlags=shared
# ExecStart=
# ExecStart=/usr/bin/docker daemon \
#  -H fd:// \
#  --mtu 1400
# _EOF_

# cat > /etc/systemd/system/docker.service.d/kolla.conf << _EOF_
# [Service]
# MountFlags=shared
# ExecStart=
# ExecStart=/usr/bin/dockerd --mtu 1400
# _EOF_

# systemctl daemon-reload && \
# systemctl restart docker || exit 1

# kolla-ansible pull -i $inventory || exit 1

# kolla-build || exit 1

# while [ true ]; do
#     netstat -nptl | grep "$kolla_internal_vip_address:80" && break
#     sleep 1
# done
#
# . /etc/kolla/admin-openrc.sh || exit 1
# init-runonce
