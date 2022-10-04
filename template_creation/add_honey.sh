#!/bin/bash

if [ ! $# -eq 1 ]
then
  echo "Usage: ./add_honey [container name]"
  exit 1
fi

CONTAINER_NAME=$1

CMDS=()

CMDS+=("sudo apt install nodejs")
CMDS+=("echo --- node things ---")
CMDS+=("sudo apt remove nodejs")

# Execute CMDs
for cmd in "${CMDS[@]}"
do
  sudo lxc-attach -n $CONTAINER_NAME -- bash -c "$cmd"
done