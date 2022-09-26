#!/bin/bash

if [ ! $# -eq 1 ]
then
  echo "Usage: ./poison_downloads [container name]"
  exit 1
fi

# This should be mostly copied from last year. My version (Lana) was really messy
# and was wrong, so someone else's should be placed here

# You can place the poisoned wget and curl files into the "poisoned_versions" folder
