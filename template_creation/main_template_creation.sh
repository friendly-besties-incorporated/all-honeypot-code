#!/bin/bash

if [ ! $# -eq 2 ]
then
  echo "Usage: ./main_template_creation [template name] [path to website]"
  echo "If control, path to website should just be N"
  exit 1
fi

# Steps/things to do here. Probably not exhaustive
# When possible/appropriate, make code into a new script. It's easier to swap
# code in and out that way

# Create it!
sudo lxc-create -n "$1" -t download -- -d ubuntu -r focal -a amd64
sudo lxc-start -n "$1"

# Install openssh and apache
sudo lxc-attach -n "$1" -- bash -c "sudo apt-get install openssh-server"
if [ -d "$2" ]
then
  sudo lxc-attach -n "$1" -- bash -c "sudo apt-get install apache2"

  # Set up apache!
  /bin/bash ./setup_apache.sh "$1" "$2"
fi

# Add honey
echo "Adding honey..."
/bin/bash ./add_honey.sh "$1"

# Poison wget and curl
echo "Poisoning downloads..."
/bin/bash ./poison_downloads.sh "$1"

# Is there anything else? TODO

# Stop it
sudo lxc-stop -n "$1"

# Note: we need to test how apache reacts to being copied lmao. Should be okay though.
