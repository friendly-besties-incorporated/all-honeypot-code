#!/bin/bash

# This scripts intended use is for after a reboot, needing to recycle containers that weren't recycled due to a reboot. Ran in crontab.

# Delete the old containers
for i in $(sudo lxc-ls | grep running)
do
    sudo lxc-stop $i
    sudo lxc-destroy $i
done

# Create and start all the containers again
/home/student/all-honeypot-code/running_hpot_code/start_all_honeypots.sh
