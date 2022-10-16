#!/bin/bash

# Start all four honeypots. 
# smthn like
# /bin/bash ./main_script [templ name] [external ip for this experiment] [mitm port] [interface]
# four times

# Ensure that host firewall rules are present
#sudo /bin/bash ./start_up/basic_firewall_rules.sh

# Fetch honeypot environment variables
source honeypot_environment

# setup traps
function kill_all_children()
{
    JOBS=$(jobs -p)
    for job_id in $JOBS
    do
        kill $job_id
    done
}

function wait_all_children()
{
    JOBS=$(jobs -p)
    for job_id in $JOBS
    do
        wait $job_id
        echo "$job_id exited."
    done
}

function safe_exit()
{
    # undo trap
    trap - safe_exit EXIT SIGTERM SIGINT

    echo "stopping all honey pots now"
    kill_all_children
    wait_all_children

    echo "all honeypots stopped, exiting now."
    exit
}

trap safe_exit EXIT SIGTERM SIGINT

# use CNAME_CONTROL, CNAME_DITINFO, CNAME_DIDPSWD, and CNAME_IOTPAGE for the template names

/bin/bash ./serve_honeypot.sh "$CNAME_CONTROL" "$IP_CONTROL" "$PORT_CONTROL" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_DITINFO" "$IP_DITINFO" "$PORT_DITINFO" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_DITINFO2" "$IP_DITINFO2" "$PORT_DITINFO2" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_DIDPSWD" "$IP_DIDPSWD" "$PORT_DIDPSWD" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_DIDPSWD2" "$IP_DIDPSWD2" "$PORT_DIDPSWD2" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_IOTPAGE" "$IP_IOTPAGE" "$PORT_IOTPAGE" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_IOTPAGE2" "$IP_IOTPAGE2" "$PORT_IOTPAGE2" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_BLANK" "$IP_BLANK" "$PORT_BLANK" "$INFACE" &
/bin/bash ./serve_honeypot.sh "$CNAME_BLANK2" "$IP_BLANK2" "$PORT_BLANK2" "$INFACE" &
/bin/bash ./cron_jobs/tcpdump_80.sh &

#wait_all_children
