#!/bin/bash

IPTABLES=/sbin/iptables

WAN=ens160
LAN=ens192


$IPTABLES -N internet -t mangle

$IPTABLES -t mangle -A PREROUTING -j internet

$IPTABLES -t mangle -A internet -j MARK --set-mark 99

$IPTABLES -t nat -A PREROUTING -m mark --mark 99 -p tcp --dport 80 -j DNAT --to-destination 192.168.33.1

#$IPTABLES -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
#$IPTABLES -t filter -A INPUT -p udp --dport 53 -j ACCEPT
#$IPTABLES -t filter -A INPUT -m mark --mark 99 -j DROP

echo "1" > /proc/sys/net/ipv4/ip_forward

$IPTABLES -A FORWARD -i $WAN -o $LAN -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -m mark --mark 99 -j REJECT
$IPTABLES -A FORWARD -i $LAN -o $WAN -j ACCEPT
$IPTABLES -t nat -A POSTROUTING -o $WAN -j MASQUERADE

