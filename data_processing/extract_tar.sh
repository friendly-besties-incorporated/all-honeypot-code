#!/bin/bash

# Use this to extract the poisoned downloads .tar files in sandbox.

if [ ! $# -eq 1 ]
then
        echo "Usage: ./extract_tar [path to log]"
        exit 1
fi

tar -xvf $1 --strip-components 8 --one-top-level
