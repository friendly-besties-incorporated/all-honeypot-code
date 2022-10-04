#!/bin/bash

interface="enth1pormsthn"
logpath="$H_P_LOGSTORE""/icmp"

control_path="$logpath""/""$CNAME_CONTROL"
ditinfo_path="$logpath""/""$CNAME_DITINFO"
didpswd_path="$logpath""/""$CNAME_DIDPSWD"
iotpage_path="$logpath""/""$CNAME_IOTPAGE"

sudo mkdir -p "$control_path" "$ditinfo_path" "$didpswd_path" "$iotpage_path"

sudo tcpdump -i "$interface" 'icmp port 80 or icmp port 443' dst "$IP_CONTROL" -G 86400 -w "$control_path""/icmplog-%m-%d"
sudo tcpdump -i "$interface" 'icmp port 80 or icmp port 443' dst "$IP_DITINFO" -G 86400 -w "$ditinfo_path""/icmplog-%m-%d"
sudo tcpdump -i "$interface" 'icmp port 80 or icmp port 443' dst "$IP_DIDPSWD" -G 86400 -w "$didpswd_path""/icmplog-%m-%d"
sudo tcpdump -i "$interface" 'icmp port 80 or icmp port 443' dst "$IP_IOTPAGE" -G 86400 -w "$iotpage_path""/icmplog-%m-%d"
