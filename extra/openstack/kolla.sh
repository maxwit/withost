#!/usr/bin/env bash

if [ $UID == 0 ]; then
    echo "do NOT run as root!"
    exit 1
fi

function get_ip {
    ip a s dev $1 | grep -e "inet\s.*brd" | awk '{print $2}' | awk -F '/' '{print $1}'
}

# FIXME
kolla_mode='pip' # or git

openstack_release=${openstack_release:-stein}

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

if [ -z "$network_interface" -o -z "$neutron_external_interface" ]; then
	# FIXME
	interface_list=(`ip a | grep -owe "\s[ew][0-9a-zA-Z]\+:" | sed 's/://g'`)
	if [ ${#interface_list[@]} == 0 ]; then
	  echo "no NIC found!"
	  exit 1
	fi

	for ifx in ${interface_list[@]}; do
	    ipv4=`get_ip $ifx`
	    if [ -z "$ipv4" -a -z "$neutron_external_interface" ]; then
	        neutron_external_interface=$ifx
	    elif [ ! -z "$ipv4" -a -z "$network_interface" ]; then
	        network_interface=$ifx
	    fi

		if [ ! -z "$network_interface" -a ! -z "$neutron_external_interface" ]; then
			break
		fi
	done
fi

if [ -z "$network_interface" -o -z "$neutron_external_interface" ]; then
    echo "network interface error:"
    echo "    network_interface='$network_interface'"
    echo "    neutron_external_interface='$neutron_external_interface'"
    exit 1
fi

ipv4=(`get_ip $network_interface | sed 's/\./ /g'`)
if [ ${#ipv4[@]} -eq 0 ]; then
	echo "No IP assigned for '$network_interface'"
	exit 1
fi
ipv4[3]=$(((ipv4[3]+100)%200))
kolla_internal_vip_address=${ipv4[0]}.${ipv4[1]}.${ipv4[2]}.${ipv4[3]}

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
    # TODO: add exception handler here
    kolla-ansible -i $inventory $task
done

kolla-ansible post-deploy || exit 1

grep -q OpenStack ~/.bashrc || cat >> ~/.bashrc << EOF
# OpenStack
source $ENVPATH/bin/activate
. /etc/kolla/admin-openrc.sh
EOF

echo 'Done!'
