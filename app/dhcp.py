from lib import base

def get_pattern(conf):
    #FIXME
    netmask = "255.255.255.0"

    gateway = base.get_gateway()

    mask_arr = netmask.split('.')
    gw_arr = gateway.split('.')
    net_arr = [str(int(gw_arr[i]) & int(mask_arr[i])) for i in range(0, 4)]
    network = '.'.join(net_arr)

    range_min = '.'.join(net_arr[0 : 3]) + '.100'
    range_max = '.'.join(net_arr[0 : 3]) + '.200'

    if not conf.has_key('net.domain'):
        raise Exception('domain name NOT configured!')
    domain_name = conf['net.domain']

    if conf.has_key('net.ip'):
        domain = conf['net.ip']
    else:
        ifx = base.get_default_ifx()
        if ifx is None:
            raise Exception('Fail to find default NIC!')

        domain = base.get_ip(ifx)

    pattern = {
        '__GATEWAY__' : gateway,
        '__NETWORK__' : network,
        '__NETMASK__' : netmask,
        '__RANGEMIN__' : range_min,
        '__RANGEMAX__' : range_max,
        '__DOMAINNAME__' : domain_name,
        '__DOMAINADDR__' : domain,
    }

    return pattern

def setup(dist, apps):
    dhcp_conf = '/etc/dhcp/dhcpd.conf'

    pattern = get_pattern(conf)
    base.render_to_file(dhcp_conf, app/site/dhcpd.conf', pattern)

def remove(dist, conf, apps):
    pass
