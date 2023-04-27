#! /bin/bash

read -p "interface name: " intf
read -p "ip addr: " addr
read -p "sub net: " sub
read -p "gate way: " gate
read -p "dns ips: (format: 8.8.8.8, 1.1.1.1, 8.8.4.4): " dns

sudo touch /etc/netplan/01-netcfg.yaml

sudo echo -e "network:
  version: 2
  renderer: networkd
  ethernets:
    $intf:
      addresses:
        - $addr/$sub
      gateway4: $gate
      nameservers:
        addresses: [$dns]" >> /etc/netplan/01-netcfg.yaml

sudo netplan apply

ip addr show dev $intf
