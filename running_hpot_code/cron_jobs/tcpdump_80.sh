#!/bin/bash

interface="enp4s2"
username="student"
logpath="$H_P_LOGSTORE""/tcpdump"
http_filter="tcp port 80"
filename="tcpdump_%y_%m_%d_%H_%M_%S.pcap"

control_path="$logpath""/""$CNAME_CONTROL"
ditinfo_path="$logpath""/""$CNAME_DITINFO"
ditinfo2_path="$logpath""/""$CNAME_DITINFO2"
didpswd_path="$logpath""/""$CNAME_DIDPSWD"
didpswd2_path="$logpath""/""$CNAME_DIDPSWD2"
iotpage_path="$logpath""/""$CNAME_IOTPAGE"
iotpage2_path="$logpath""/""$CNAME_IOTPAGE2"
blank_path="$logpath""/""$CNAME_BLANK"
blank2_path="$logpath""/""$CNAME_BLANK2"

sudo mkdir -p "$control_path" "$ditinfo_path" "$ditinfo2_path" "$didpswd_path" "$didpswd2_path" "$iotpage_path" "$iotpage2_path" "$blank_path" "$blank2_path"

# start captures
sudo tcpdump -i "$interface" -G 86400 -U -w "$control_path""/$filename" "$http_filter and dst $IP_CONTROL" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$ditinfo_path""/$filename" "$http_filter and dst $IP_DITINFO" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$ditinfo2_path""/$filename" "$http_filter and dst $IP_DITINFO2" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$didpswd_path""/$filename" "$http_filter and dst $IP_DIDPSWD" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$didpswd2_path""/$filename" "$http_filter and dst $IP_DIDPSWD2" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$iotpage_path""/$filename" "$http_filter and dst $IP_IOTPAGE" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$iotpage2_path""/$filename" "$http_filter and dst $IP_IOTPAGE2" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$blank_path""/$filename" "$http_filter and dst $IP_BLANK" &
sudo tcpdump -i "$interface" -G 86400 -U -w "$blank2_path""/$filename" "$http_filter and dst $IP_BLANK2" &
