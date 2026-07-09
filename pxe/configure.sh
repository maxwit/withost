#!/bin/sh

netdev=${1:-tap0}
network="192.168.111.1/24"

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
dhcp-boot=u-boot-hi3516ev200-demb.bin,${tftpser}

log-dhcp
log-queries
__EOF__
