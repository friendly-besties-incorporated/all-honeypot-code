#!/bin/bash

# This script will start and serve a specified honeypot. It will take in a) container name to duplicate and b) the IP to map it to c) the mitm port
# Ideally, we would turn it on once and then leave it on for the whole month. 

if [ ! $# -eq 4 ]
then
  echo "Usage: ./serve_honeypot.sh [template container name] [external IP] [MITM port] [interface]"
  exit 1
fi

TEMPLATE_CONTAINER_NAME=$1
EXTERNAL_IP=$2
MITM_PORT=$3
EXTERNAL_INTERFACE=$4

# --- Configure variables ---

running_cont="$TEMPLATE_CONTAINER_NAME""_running"
pathtomitm="../MITM" # CHANGE TO WHERE MITM IS IF NOT HERE

# TODO currently this is repeated here and in process_complete. Gotta fix that
path_to_log_store_hpothost="$H_P_LOGSTORE""/""$TEMPLATE_CONTAINER_NAME"
path_to_dl_store_sandbox="$S_P_DLDSTORE""/""$TEMPLATE_CONTAINER_NAME"

# Check if the folder for this template already exists
if [ ! -d "$path_to_log_store_hpothost" ]
then
  sudo mkdir "$path_to_log_store_hpothost"
fi

# Make the sandbox folder. Send mkdir -p path to the sandbox container
sandbox="$S_IP"
#ssh logs@$sandbox "sudo mkdir -p $path_to_dl_store_sandbox"
# Not tested TODO

# --- Serve honeypot ---
serving=1

# Create an interrupt function that will update the serve flag to stop looping.
force_exit=0
stop_serving() 
{
  if [ $force_exit -eq 0 ]
  then
    echo "Received inturrupt signal, stopping now (hit Ctrl+C again to force exit)."
    serving=0
    force_exit=1
  else
    echo "Forcing exit NOW!"
    exit 
  fi
}

trap stop_serving INT

while [ $serving -eq 1 ]
do
  # Create the container
  echo "Creating container"
  sudo lxc-copy -n "$TEMPLATE_CONTAINER_NAME" -N "$running_cont"
  sudo lxc-start -n "$running_cont"

  sleep 5

  ip=$(sudo lxc-info -n "$running_cont" -iH)

  # Add NAT rules. For now, in a separate script
  echo "Adding nat rules"
  /bin/bash ./nat_rules.sh "add" "$ip" "$EXTERNAL_IP" "$MITM_PORT" "$EXTERNAL_INTERFACE"

  # Probably start apache? Maybe start openssh?
  # TODO Figure out if we need to start these services
  #
  # Run, and kill by broken pipe
  # Note: this requires a modified MITM
  echo "Starting mitm"
  sudo node "$pathtomitm"/mitm.js -n "$running_cont" -i "$ip" -l "10.0.3.1" -p "$MITM_PORT" --auto-access --auto-access-fixed 1 --debug -e
  echo "Ending mitm, deleting nat rules"
  # Delete NAT rules right away
  /bin/bash ./nat_rules.sh "delete" "$ip" "$EXTERNAL_IP" "$MITM_PORT" "$EXTERNAL_INTERFACE"

  # All logs will have this same name
  end_time=$( date "+%F-%H-%M-%S" )
  log_name="$TEMPLATE_CONTAINER_NAME""_""$end_time"

  # Process the complete container: move downloaded files, anything else
  echo "Processing complete cotnainer"
  /bin/bash ./process_complete_container.sh "$TEMPLATE_CONTAINER_NAME" "$running_cont" "$log_name"

  # Delete the container
  echo "Stopping and destroying container"
  sudo lxc-stop -n "$running_cont"
  sudo lxc-destroy -n "$running_cont"

  sleep 5
done
