#!/bin/bash

if [ ! $# -eq 1 ]
then
  echo "Usage: ./add_honey [container name]"
  exit 1
fi

# Add honey here! We still need to decide what else will exist in the containers,
# but we do need at least something to sit here
