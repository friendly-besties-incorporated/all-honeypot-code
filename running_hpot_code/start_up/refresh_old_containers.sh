#!/bin/bash

# This scripts intended use is for after a reboot, needing to recycle containers that weren't recycled due to a reboot. Ran in crontab.

cd ..
# Process any data from the old containers
for i in $(sudo lxc-ls -l | grep running)
do
    sudo lxc-start "$i"
    sleep 5
    end_time=$( date "+%F-%H-%M-%S" )
    # This captures everything but _running in the container name
    template_name=${i%_running}
    log_name="$template_name""_""$end_time"
    running_cont="$i"
    /bin/bash ./process_complete_container.sh "$template_name" "$running_cont" "$log_name"
done

# Delete the old containers
for i in $(sudo lxc-ls -l | grep running)
do
    sudo lxc-stop "$i"
    sleep 2
    sudo lxc-destroy "$i"
done

# Create and start all the containers again
/bin/bash ./start_all_honeypots.sh
cd start_up || exit
