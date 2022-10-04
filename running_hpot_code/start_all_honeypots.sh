#!/bin/bash

# Start all four honeypots. 
# smthn like
# /bin/bash ./main_script [templ name] [external ip for this experiment] [mitm port] [interface]
# four times

# use CNAME_CONTROL, CNAME_DITINFO, CNAME_DIDPSWD, and CNAME_IOTPAGE for the template names

/bin/bash ./main_script $CNAME_CONTROL $IP_CONTROL more
/bin/bash ./main_script $CNAME_DITINFO $IP_DITINFO more
/bin/bash ./main_script $CNAME_DIDPSWD $IP_DIDPSWD more
/bin/bash ./main_script $CNAME_IOTPAGE $IP_IOTPAGE more
