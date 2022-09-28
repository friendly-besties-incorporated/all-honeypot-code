if [ ! $# -eq 2 ]
then
    echo "Usage: ./process_complete_container [container name] [folder path (start with '/' - ROOT)]"
  exit 1
fi

cname=$1
dir=$2
hostdir="/var/lib/lxc/$cname/rootfs$dir" # need sudo
sandbox="10.2.0.2"

sudo lxc-attach -n $cname -- bash -c "zip -r $cname.zip $dir"
sudo scp -i ~/.ssh/id_rsa.pub $hostdir/$cname.zip logs@$sandbox:~/downloads/$cname.zip
# requires the account executing to have ssh authentication with logs@sandbox
# THE SSH PART IS NOT QUITE WORKING YET



# This file will take in a container and process any files that are on it. For example, moving the
# downloaded files to the sandbox, stuff like that.

# Name the folder "folder name", wherever you end up putting it, so that we can match mitm logs to 
