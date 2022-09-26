#!/bin/bash

# This script will be the main script. It will take in a) container name to duplicate and b) the IP to map it to c) the mitm port
# Ideally, we would turn it on once and then leave it on for the whole month. 

if [ ! $# -eq 3 ]
then
  echo "Usage: ./main_script [template container name] [external IP] [MITM port] [interface]"
  exit 1
fi

running_cont="$1_running"

pathtomitm = "../MITM" # CHANGE TO WHERE MITM IS IF NOT HERE

path_to_logs="/var/mitm_logs/""$1"
# Check if the folder for this template already exists
if [ ! -d "$path_to_logs" ]
then
  sudo mkdir "$path_to_logs"
fi


# This is where we'd "leave it on" for the whole month comes from.
while true
do
  # Create the container
  sudo lxc-copy -n "$1" -N "$running_cont"
  sudo lxc-start -n "$running_cont"

  sleep 5
  
  ip=$(sudo lxc-info -n "$snoopyrun" -iH)
  
  # Add NAT rules. For now, in a separate script
  /bin/bash ./nat_rules "add" "$ip" "$2" "$3" "$4"
  
  # Probably start apache? Maybe start openssh?
  # TODO Figure out if we need to start these services
  
  # Run, and kill by broken pipe
  # Note: this requires a modified MITM
  sudo node "$pathtomitm"/mitm.js -n "$running_cont" -i "$ip" -p "$3" --auto-access --auto-access-fixed 1 --debug | sed -n -e "/Container's OpenSSH server ended connection/q"
  
  # Delete NAT rules right away
  /bin/bash ./nat_rules "delete" "$ip" "$2" "$3" "$4"
  
  # In here, move the MITM data
  # First, make the name the log will have
  end_time=$( date "+%F-%T-%Z" )
  log_name="$1""_""$end_time"
  mitmfile=$( ls "$pathtomitm"/logs/session_streams -t | head -1 )
  # Copy the file into the proper folder
  cp "$pathtomitm"/logs/session_streams/"$mitmfile" "$path_to_logs""/""$log_name"
  
  # Process the complete container: move downloaded files, anything else
  /bin/bash ./process_complete_container "$running_cont" "$log_name"
  
  # Delete the container
  sudo lxc-stop -n "$running_cont"
  sudo lxc-destroy -n "$running_cont"
  
  sleep 5
  
 done
  
