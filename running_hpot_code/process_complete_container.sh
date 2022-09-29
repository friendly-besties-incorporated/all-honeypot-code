if [ ! $# -eq 3 ]
then
  echo "Usage: ./process_complete_container [template name] [container name] [log name]"
  exit 1
fi

cname="$1"
tname="$1"
path_to_mitm="../MITM"
path_to_log_store_hpothost="/var/experiment_logs/""$tname"
path_to_dl_store_sandbox="/var/experiment_downloads/""$tname"
path_to_container="/var/lib/lxc/$cname/rootfs" # need sudo

# All logs will have this name, given by variables
log_name="$2"

# STEP ONE: LOGS INTO HPOTHOST BACKUP
# Find the most recent MITM file (possible data frace here)
mitmfile=$( ls "$path_to_mitm"/logs/session_streams -t | head -1 )
# Find the apache log file TODO this could be incorrect
apachefile="$path_to_container""/var/log/apache/access.log"
# Zip up the two files into an archive with the log_name
zip "$log_name" mitmfile apachefile -j

# Move the zip file into the proper folder
mv "$log_name".zip "$path_to_log_store_hpothost"



# STEP TWO: DOWNLOADS INTO SANDBOX VM
sandbox="10.2.0.2"
dir="/var/log/.downloads"

sudo lxc-attach -n $cname -- bash -c "zip -r $log_name.zip $dir"
sudo scp -i ~/.ssh/id_rsa.pub $path_to_container/$log_name.zip logs@$sandbox:~/$path_to_dl_store_sandbox/$log_name.zip
# TODO connect properly
# requires the account executing to have ssh authentication with logs@sandbox
# THE SSH PART IS NOT QUITE WORKING YET


