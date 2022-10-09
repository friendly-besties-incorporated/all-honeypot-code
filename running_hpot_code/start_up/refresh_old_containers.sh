#!/bin/bash

# This scripts intended use is for after a reboot, needing to recycle containers that weren't recycled due to a reboot. Ran in crontab.

# Process any data from the old containers
for i in $(sudo lxc-ls | grep running)
do
    sudo lxc-start $i
    sleep 5
    log_name="$i""_""$end_time"
    running_cont="$i_running"
    /bin/bash ./process_complete_container.sh "$i" "$running_cont" "$log_name"
done

# Delete the old containers
for i in $(sudo lxc-ls | grep running)
do
    sudo lxc-stop $i
    sleep 2
    sudo lxc-destroy $i
done

# Create and start all the containers again
/bin/bash /home/student/all-honeypot-code/running_hpot_code/start_all_honeypots.sh
