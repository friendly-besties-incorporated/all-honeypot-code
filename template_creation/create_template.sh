#!/bin/bash

if [ ! $# -eq 2 ]
then
  echo "Usage: ./create_template.sh [template name] [path to website]"
  echo "If control, path to website should just be N"
  exit 1
fi

TEMPLATE_NAME=$1
PATH_TO_WEBSITE=$2

# Check if the container already exists
already_running=$(sudo lxc-ls | grep -c -w "$TEMPLATE_NAME")
if [ $already_running -ne 0 ]
then
  echo "Error: a container with the name \"$TEMPLATE_NAME\" already exists!"
  exit 2
fi

# Steps/things to do here. Probably not exhaustive
# When possible/appropriate, make code into a new script. It's easier to swap
# code in and out that way

# Create it!
sudo lxc-create -n "$TEMPLATE_NAME" -t download -- -d ubuntu -r focal -a amd64
sudo lxc-start -n "$1"

# Wait a lil' bit for the container to fully start.
sleep 5

# Install openssh and apache
sudo lxc-attach -n "$TEMPLATE_NAME" -- bash -c "sudo apt-get install openssh-server -y"
if [ -d "$PATH_TO_WEBSITE" ]
then
  sudo lxc-attach -n "$TEMPLATE_NAME" -- bash -c "sudo apt-get install apache2 -y"

  # Set up apache!
  /bin/bash ./setup_apache.sh "$TEMPLATE_NAME" "$PATH_TO_WEBSITE"
fi

# Add honey
echo "Adding honey..."
sudo /bin/bash ./add_honey.sh "$TEMPLATE_NAME" "./db-faker"

# Poison wget and curl
echo "Poisoning downloads..."
/bin/bash ./poison_downloads.sh "$TEMPLATE_NAME"

echo "Template creation complete, stopping container..."

# Stop it
sudo lxc-stop -n "$1"

echo "Done!"
