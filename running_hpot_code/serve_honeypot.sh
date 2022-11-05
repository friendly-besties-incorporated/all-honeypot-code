#!/bin/bash

# This script will start and serve a specified honeypot. It will take in a) container name to duplicate and b) the IP to map it to c) the mitm port
# Ideally, we would turn it on once and then leave it on for the whole month. 

echo "entering serve_honeypot"

if [ ! $# -eq 5 ]
then
  echo "Usage: ./serve_honeypot.sh [template container name] [external IP] [MITM port] [interface] [experiment num, 1 or 2]"
  exit 1
fi

# Fetch honeypot environment variables
source honeypot_environment

TEMPLATE_CONTAINER_NAME=$1
EXTERNAL_IP=$2
MITM_PORT=$3
EXTERNAL_INTERFACE=$4
EXP_NUM=$5

echo "actually in serve_honeypot"

# --- Configure variables ---

true_template_name="$TEMPLATE_CONTAINER_NAME"

if [[ $EXP_NUM == 2 ]]
then
  echo "Experiment number was two, 'changing' template container name"
  TEMPLATE_CONTAINER_NAME="$TEMPLATE_CONTAINER_NAME""-2"
  echo "It is now ""$TEMPLATE_CONTAINER_NAME"
fi

running_cont="$TEMPLATE_CONTAINER_NAME""_running"
pathtomitm="../MITM" # CHANGE TO WHERE MITM IS IF NOT HERE

# TODO currently this is repeated here and in process_complete. Gotta fix that
path_to_log_store_hpothost="$H_P_LOGSTORE""/""$TEMPLATE_CONTAINER_NAME"
path_to_dl_store_sandbox="$S_P_DLDSTORE""/""$TEMPLATE_CONTAINER_NAME"

echo "before mkdir"

# Check if the folder for this template already exists
#sudo mkdir -p "$path_to_log_store_hpothost"
echo "Mkdir is manual for now. Please ensure the proper folder exists:" "$path_to_log_store_hpothost"

echo "before sandnox"

# Make the sandbox folder. Send mkdir -p path to the sandbox container
sandbox="$S_IP"
#ssh logs@"$sandbox" "mkdir -p i ""$path_to_dl_store_sandbox"
echo "temporarily disabled"

# Not tested TODO

# --- Serve honeypot ---

function cleanup_honeypot()
{ 
  # Delete NAT rules right away
  /bin/bash ./nat_rules.sh "delete" "$ip" "$EXTERNAL_IP" "$MITM_PORT" "$EXTERNAL_INTERFACE"

  # All logs will have this same name
  end_time=$( date "+%F-%H-%M-%S" )
  log_name="$TEMPLATE_CONTAINER_NAME""_""$end_time"

  # Process the complete container: move downloaded files, anything else
  echo "Processing complete cotnainer"
  /bin/bash ./process_complete_container.sh "$TEMPLATE_CONTAINER_NAME" "$running_cont" "$log_name"

  # Undo any write-locked files
  path_to_container="/var/lib/lxc/$cname/rootfs" 
  sudo chattr -i -R $path_to_container

  # Delete the container
  echo "Stopping and destroying container"
  sudo lxc-stop -n "$running_cont"
  sudo lxc-destroy -n "$running_cont"
}

function safe_exit()
{
  # undo trap
  trap - EXIT SIGTERM SIGINT

  echo "Got EXIT signal, will safely exit now."
  
  # tell mitm.js to DIE
  sudo kill $mitm_pid

  cleanup_honeypot
  
  exit
}

trap safe_exit EXIT SIGTERM SIGINT

echo "starting to serve"

while true
do
  # Create the container
  echo "Creating container"
  sudo lxc-copy -n "$true_template_name" -N "$running_cont"

  # Start container
  sudo lxc-start -n "$running_cont"

  ip=""
  while [[ $ip == "" ]]
  do
      #ip=$(sudo lxc-ls -f -F name,IPV4 | grep -w "^$running_cont" | awk '{ print $2 }')
      ip=$(sudo lxc-info -n "$running_cont" -iH)
      echo "Currently ip of $running_cont is" $ip
      sleep 1
  done

  echo "before hostname"
  # Edit hostname
  sudo lxc-attach -n $running_cont -- bash -c "sudo hostname is-admin"
  
  echo "before nat rules"
# Add NAT rules. For now, in a separate script
  echo "Adding nat rules"
  /bin/bash ./nat_rules.sh "add" "$ip" "$EXTERNAL_IP" "$MITM_PORT" "$EXTERNAL_INTERFACE"

  # a cached exit will have an exit code of 100
  mitm_exit_code=100

  while [ $mitm_exit_code -eq 100 ]
  do
    # Run MITM`
    echo "Starting mitm"
    sudo node "$pathtomitm"/mitm.js -n "$running_cont" -i "$ip" -l "10.0.3.1" -p "$MITM_PORT" --auto-access --auto-access-fixed 1 --debug --logging-attacker-streams "$pathtomitm"/logs/session_streams/"$TEMPLATE_CONTAINER_NAME" -s 3600 -e 0 -cc './command-cache.json' -al 1 &
    mitm_pid=$!
    wait $mitm_pid
    mitm_exit_code=$?
  done

  echo "Ending mitm, deleting nat rules"

  cleanup_honeypot

  # Wait extra delay to slow down recycling
  MINWAIT=30
  MAXWAIT=150
  random_delay=$((MINWAIT+RANDOM % (MAXWAIT-MINWAIT)))
  echo "Waiting $random_delay seconds before restarting..."
  sleep $random_delay

done
