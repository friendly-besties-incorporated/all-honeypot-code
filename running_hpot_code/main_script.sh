#!/bin/bash

# This script will be the main script. It will take in a) container name to duplicate and b) the IP to map it to c) the mitm port
# Ideally, we would turn it on once and then leave it on for the whole month. 

if [ ! $# -eq 4 ]
then
  echo "Usage: ./main_script [template container name] [external IP] [MITM port] [interface]"
  exit 1
fi

running_cont="$1_running"
pathtomitm="../MITM" # CHANGE TO WHERE MITM IS IF NOT HERE

# TODO currently this is repeated here and in process_complete. Gotta fix that
path_to_log_store_hpothost="$H_P_LOGSTORE""/""$1"
path_to_dl_store_sandbox="$S_P_DLDSTORE""/""$1"

# Check if the folder for this template already exists
if [ ! -d "$path_to_log_store_hpothost" ]
then
  sudo mkdir "$path_to_log_store_hpothost"
fi

# Make the sandbox folder. Send mkdir -p path to the sandbox container
sandbox="$S_IP"
#ssh logs@$sandbox "sudo mkdir -p $path_to_dl_store_sandbox"
# Not tested TODO

# This is where we'd "leave it on" for the whole month comes from.
#while true
#do
  # Create the container
  echo "Creating container"
  sudo lxc-copy -n "$1" -N "$running_cont"
  sudo lxc-start -n "$running_cont"

  sleep 5

  ip=$(sudo lxc-info -n "$running_cont" -iH)

  # Add NAT rules. For now, in a separate script
  echo "Adding nat rules"
  /bin/bash ./nat_rules.sh "add" "$ip" "$2" "$3" "$4"

  # Probably start apache? Maybe start openssh?
  # TODO Figure out if we need to start these services
  #
  # Run, and kill by broken pipe
  # Note: this requires a modified MITM
  echo "Starting mitm"
  sudo node "$pathtomitm"/mitm.js -n "$running_cont" -i "$ip" -p "$3" --auto-access --auto-access-fixed 1 --debug -e
  echo "Ending mitm, deleting nat rules"
  # Delete NAT rules right away
  /bin/bash ./nat_rules.sh "delete" "$ip" "$2" "$3" "$4"

  # All logs will have this same name
  end_time=$( date "+%F-%T-%Z" )
  log_name="$1""_""$end_time"

  # Process the complete container: move downloaded files, anything else
  echo "Processing complete cotnainer"
  /bin/bash ./process_complete_container.sh "$1" "$running_cont" "$log_name"

  # Delete the container
  echo "Not! Stopping and destroying container"
  #sudo lxc-stop -n "$running_cont"
  #sudo lxc-destroy -n "$running_cont"

  sleep 5
#done
