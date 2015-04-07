#!/bin/sh
iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p tcp --dport ${DOCKER_PORT} -j DNAT --to-destination ${IPTABLES_DEST_IP}:${IPTABLES_DEST_PORT}
iptables -t nat -A POSTROUTING -m addrtype --src-type LOCAL --dst-type UNICAST -j MASQUERADE
sysctl -w net.ipv4.conf.all.route_localnet=1

tlspretense run
