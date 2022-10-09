#!/bin/bash

if [ ! $# -eq 5 ]
then
  echo "Usage: ./nat_rules [add/delete] [container ip] [external ip] [mitm port] [interface]"
  exit 1
fi

myip=$(hostname -I | cut -d' ' -f1)

if [[ "$1" == "add" ]]
then
  sudo ip addr add "$3"/24 brd + dev "$5"
  sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination "$3" --jump DNAT --to-destination "$2"
  sudo iptables --table nat --insert POSTROUTING --source "$2" --destination 0.0.0.0/0 --jump SNAT --to-source "$3"

  sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination "$3" --protocol tcp --dport 22 --jump DNAT --to-destination "127.0.0.1":"$4"
  
  # TODO: Figure out if we need to add anything for the web servers. 
  
 else
  sudo ip addr del "$3"/24 brd + dev "$5"
  sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0 --destination "$3" --jump DNAT --to-destination "$2"
  sudo iptables --table nat --delete POSTROUTING --source "$2" --destination 0.0.0.0/0 --jump SNAT --to-source "$3"

  sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0 --destination "$3" --protocol tcp --dport 22 --jump DNAT --to-destination "127.0.0.1":"$4"
 fi