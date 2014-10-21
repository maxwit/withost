import os
from lib import base

def get_pattern(conf):
    router = conf['sys.router'].strip()

    #FIXME
    netmask = "255.255.255.0"
    domain_name = 'maxwit.com'
    domain_server = router

    router_arr = router.split('.')[0 : 4]
    netmask_arr = netmask.split('.')
    nega_netmask_arr = [(255 - int(num)) for num in netmask_arr]
    network_arr = [str(int(router_arr[cnt]) & int(netmask_arr[cnt])) for cnt in range(0, 4)]

    network = '.'.join(network_arr)
    range_min = '.'.join(network_arr[0 : 3]) + '.' + str(int(network_arr[3]) + 1)

    range_max_pre = [str(nega_netmask_arr[cnt] + int(network_arr[cnt])) for cnt in range(0, 3)]
    range_max_suf = nega_netmask_arr[3] + int(network_arr[3]) - 1
    range_max = '.'.join(range_max_pre) + '.' + str(range_max_suf)

    if router != range_max:
        static_ip = '.'.join(router_arr[0 : 3]) + '.' + str(int(router_arr[3]) + 1)
    else:
        static_ip = '.'.join(router_arr[0 : 3]) + '.' + str(int(router_arr[3]) - 1)

    pattern = ({
        '__ROUTERS__' : router,
        '__NETWORK__' : network,
        '__NETMASK__' : netmask,
        '__RANGEMIN__' : range_min,
        '__RANGEMAX__' : range_max,
        '__DOMAINNAME__' : domain_name,
        '__DOMAINSERVER__' : domain_server,
    }, static_ip)

    return pattern

def setup(dist, conf, apps):
    dhcp_conf = '/etc/dhcp/dhcpd.conf'
    eth0_conf = '/etc/sysconfig/network-scripts/ifcfg-eth0'

    (pattern, static_ip) = get_pattern(conf)
    base.render_to_file(dhcp_conf, 'dist/site/dhcpd.conf', pattern)

    if os.access(eth0_conf, 6):
        with open(eth0_conf, 'r+') as file:
            lines = file.readlines()
            file.truncate(0)
            file.seek(0)

            for line in lines:
                if line.startswith('NM_CONTROLLED'):
                    line = 'NM_CONTROLLED=no\n'
                elif line.startswith('BOOTPROTO'):
                    line = 'BOOTPROTO=none\n'

	        file.write(line)

            file.write('IPADDR=%s\n' % static_ip)
            file.write('NETMASK=%s\n' % pattern['__NETMASK__'])
            file.write('GATEWAY=%s' % pattern['__ROUTERS__'])

def remove(dist, conf, apps):
	pass
