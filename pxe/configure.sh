#!/usr/bin/env bash

cd "$(dirname "$0")"

netdev=${1:-tap0}
network=$2

if [ -z "$network" ]; then
    while true
    do
        network="192.168.$((RANDOM % 100 + 100))"
        echo $network
        ip a | grep $network > /dev/null || break
    done
    network="$network.1/24"
fi

gateway=${network%/*}
subnet=${gateway%.*}
tftpser=${subnet}.10

if test ! -e /sys/class/net/$netdev; then
    echo "'$netdev' does NOT exist!"
    exit 1
fi

sudo ip link set "$netdev" up
sudo ip addr flush dev $netdev
sudo ip addr add $gateway/24 dev $netdev
sudo ip addr add $tftpser/24 dev $netdev

# pxeconf=$(mktemp)
pxeconf=./dnsmasq.conf

cat > $pxeconf << __EOF__
interface=$netdev
bind-interfaces

dhcp-range=$subnet.100,${subnet}.200,24h

# Gateway
dhcp-option=3,${gateway}
# DNS
dhcp-option=6,${gateway}

enable-tftp
tftp-root=/srv/tftp

# PXE
dhcp-boot=foo,${tftpser}

log-dhcp
log-queries
__EOF__
