if [ ! $# -eq 3 ]
then
  echo "Usage: ./process_complete_container [template name] [container name] [log name (without .zip)]"
  exit 1
fi

cname="$2"
tname="$1"
path_to_mitm="../MITM"
path_to_log_store_hpothost="$H_P_LOGSTORE""/""$tname"
path_to_dl_store_sandbox="$S_P_DLDSTORE""/""$tname"
path_to_container="/var/lib/lxc/$cname/rootfs" # need sudo

# All logs will have this name, given by variables
log_name="$3"

# STEP ONE: LOGS INTO HPOTHOST BACKUP
# Find the most recent MITM file (possible data frace here)
mitmfile=$( ls "$path_to_mitm"/logs/session_streams -t | head -1 )
mitmfile="$path_to_mitm""/logs/session_streams/""$mitmfile"
# Find the apache log file TODO this could be incorrect
apachefile="$path_to_container""/var/log/apache2/access.log"
# Zip up the two files into an archive with the log_name
sudo zip "$log_name".zip "$mitmfile" "$apachefile" -j

# Move the zip file into the proper folder
sudo mv "$log_name".zip "$path_to_log_store_hpothost"
echo "I theoretically moved the thing to $path_to_log_store_hpothost"

# STEP TWO: DOWNLOADS INTO SANDBOX VM
sandbox="$S_IP"
dir="$C_P_DLDS"

# Extract this archive with  [ tar -xvf "$log_name""_dl".tar --strip-components 7 --one-top-level]
sudo tar -cf "$log_name""_dl".tar "$path_to_container""$dir"
scp "$log_name""_dl".tar logs@$sandbox:$path_to_dl_store_sandbox/
sudo rm "$log_name""_dl".tar
# This requires the account executing to have ssh authentication with logs@sandbox. This is setup already with the student account.
