#!/bin/bash

# nat_rules.sh: Applies the firewall rules necessary in the NAT table to reroute traffic
# from the honeypot's public IPs to the honeypot's containers. 

if [ ! $# -eq 5 ]
then
  echo "Usage: ./nat_rules [add/delete] [container ip] [external ip] [mitm port] [interface]"
  exit 1
fi

myip=$(hostname -I | cut -d' ' -f1)

if [[ "$1" == "add" ]]
then
  # Bind host to public IP address
  sudo ip addr add "$3"/24 brd + dev "$5"

  # Route container <=> internet traffic
  sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination "$3" --jump DNAT --to-destination "$2"
  sudo iptables --table nat --insert POSTROUTING --source "$2" --destination 0.0.0.0/0 --jump SNAT --to-source "$3"

  # MITM redirection
  sudo sysctl -w net.ipv4.conf.all.route_localnet=1
  sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination "$3" --protocol tcp --dport 22 --jump DNAT --to-destination "127.0.0.1:$4"
 else
  sudo ip addr del "$3"/24 brd + dev "$5"
  sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0 --destination "$3" --jump DNAT --to-destination "$2"
  sudo iptables --table nat --delete POSTROUTING --source "$2" --destination 0.0.0.0/0 --jump SNAT --to-source "$3"
  sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0 --destination "$3" --protocol tcp --dport 22 --jump DNAT --to-destination "127.0.0.1":"$4"
 fi