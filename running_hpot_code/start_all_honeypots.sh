#!/bin/bash

# Start all four honeypots. 
# smthn like
# /bin/bash ./main_script [templ name] [external ip for this experiment] [mitm port] [interface]
# four times

# Ensure that host firewall rules are present
#sudo /bin/bash ./start_up/basic_firewall_rules.sh
source honeypot_environment
# use CNAME_CONTROL, CNAME_DITINFO, CNAME_DIDPSWD, and CNAME_IOTPAGE for the template names

/bin/bash ./serve_honeypot.sh "$CNAME_CONTROL" "$IP_CONTROL" "$PORT_CONTROL" "$INFACE" 
/bin/bash ./serve_honeypot.sh "$CNAME_DITINFO" "$IP_DITINFO" "$PORT_DITINFO" "$INFACE"
/bin/bash ./serve_honeypot.sh "$CNAME_DIDPSWD" "$IP_DIDPSWD" "$PORT_DIDPSWD" "$INFACE"
/bin/bash ./serve_honeypot.sh "$CNAME_IOTPAGE" "$IP_IOTPAGE" "$PORT_IOTPAGE" "$INFACE"
/bin/bash ./serve_honeypot.sh "$CNAME_BLANK" "$IP_BLANK" "$PORT_BLANK" "$INFACE"
