#!/bin/bash

if [ ! $# -eq 2 ]
then
  echo "Usage: ./setup_apache [template container name] [path to website]"
  exit 1
fi

CONTAINER_NAME=$1
WEBSITE_PATH=$2

# Ensure contanier actually exists and is running.
running=$(sudo lxc-ls | grep -c -w "$CONTAINER_NAME")
if [ $running -ne 1 ]
then
  echo "Container '$CONTAINER_NAME' does not exist!"
  exit 1
fi

# Set up the website
path_to_container="/var/lib/lxc/$CONTAINER_NAME/rootfs"
html_path="$path_to_container/var/www/html"
existing_files_count=$(sudo ls $html_path | wc -l)

# Because we are going to automate setup_apache.sh, there really isn't a need to
# manually confirm the replacement of files in the web directory.

# # If there are existing files, prompt the user to verify that they want to overwrite them.
# if [ $existing_files_count -ne 0 ]
# then
#   echo -n "Warning: $html_path has $existing_files_count file(s) already. By continuing, these files will be wiped. Is that OK? [Y/n]: "
#   read ans
#   continue=$(echo $ans | grep -c '^Y\|^y\|^$')
#   if [ $continue -eq 0 ]
#   then
#     echo "Exiting setup."
#     exit 2
#   fi
# fi

# Remove existing files. Note that you need to use an elevated bash shell to use a wildcard since it's a protected folder.
sudo bash -c "rm -r $html_path/*"

# Copy new files.
sudo cp -r "$WEBSITE_PATH"/* "$html_path"

echo "Done!"