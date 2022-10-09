#!/bin/bash

if [ ! $# -eq 1 ]
then
  echo "Usage: ./poison_downloads [container name]"
  exit 1
fi

# This should be mostly copied from last year. My version (Lana) was really messy
# and was wrong, so someone else's should be placed here

# You can place the poisoned wget and curl files into the "poisoned_versions" folder
# Check container exist
if ! sudo lxc-ls | grep -q -w "$1"
then
  echo "$1" "doesn't exist."
  exit 2
fi
# Check container running
if ! sudo lxc-info -n "$1" | grep -q -w "RUNNING"
then
  echo "$1" "isn't running."
  exit 3
fi
# If we're here, then we can now safely start making things!
# Helpful~
tocont=/var/lib/lxc/"$1"/rootfs

# wget section
tocheck="$tocont"/usr/bin/wwget
# Check if this script has already been run
if sudo test -f "$tocheck"
then
  echo "Poisoned wget already exists."
else
  # make the necessary directory
  sudo mkdir -p "$tocont"/var/log/.downloads
  # Install wget
  sudo lxc-attach -n "$1" -- bash -c "sudo apt-get install wget -y"
  # Change name and stick fakewget into the wget spot
  sudo mv "$tocont"/usr/bin/wget "$tocont"/usr/bin/wwget
  sudo cp ./poisoned_versions/fakewget "$tocont"/usr/bin/wget
fi

# wget section
tocheck="$tocont"/usr/bin/ccurl
# Check if this script has already been run
if sudo test -f "$tocheck"
then
  echo "Poisoned curl already exists on this container."
else
  # make the necessary directory
  sudo mkdir -p "$tocont"/var/log/.downloads
  # Install wget
  sudo lxc-attach -n "$1" -- bash -c "sudo apt-get install curl -y"
  # Change name and stick fakewget into the wget spot
  sudo mv "$tocont"/usr/bin/curl "$tocont"/usr/bin/ccurl
  sudo cp ./poisoned_versions/fakecurl "$tocont"/usr/bin/curl
fi
