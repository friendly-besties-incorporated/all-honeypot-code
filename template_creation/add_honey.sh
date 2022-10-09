#!/bin/bash

# Installs honey on a specified container. This is done by using the "fake.ts" script which generates
# random data and inserts it in the database. This script does the following:
# 
# 1. Install nodejs and postgresql
# 2. Copy fake.ts script and package.json to the container
# 3. Install npm packages
# 4. Execute fake.ts
# 5. Remove fake.ts & npm packages
# 6. Uninstall nodejs

if [ ! $# -eq 2 ]
then
  echo "Usage: ./add_honey [container name] [fake project path]"
  exit 1
fi

CONTAINER_NAME=$1
CONTAINER_DIRECTORY="/var/lib/lxc/$CONTAINER_NAME/rootfs/"

if [ ! -d "$CONTAINER_DIRECTORY" ] 
then
  echo "Error: Cannot add honey becuase the container directory does not exist!"
  exit 2
fi

HOST_FAKE_PATH=$2
CONTAINER_PROJECT_PATH="/root/fake"

# Copy project files to the container
sudo cp -r $HOST_FAKE_PATH "$CONTAINER_DIRECTORY""$CONTAINER_PROJECT_PATH"

CMDS=()

# Update packages
CMDS+=("apt update -y")
CMDS+=("apt upgrade -y")

# Install fake data
CMDS+=("sudo apt install postgresql -y")

# Install NodeJS (cmds from https://joshtronic.com/2021/05/09/how-to-install-nodejs-16-on-ubuntu-2004-lts/)
CMDS+=("curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -")
CMDS+=("apt install -y nodejs npm")

# Configure postgres with most secure password in the world
CMDS+=("sudo -u postgres psql -c \"ALTER USER postgres WITH PASSWORD 'postgres';\"")

CMDS+=("cd $CONTAINER_PROJECT_PATH; npm i; npm start");
CMDS+=("echo Installed fake data!")
CMDS+=("sudo apt remove nodejs npm -y")

# Execute CMDs
for cmd in "${CMDS[@]}"
do
  sudo lxc-attach -n $CONTAINER_NAME -- bash -c "$cmd"
done

# Remove project files from container
sudo rm -rf $CONTAINER_PROEJCT_PATH
