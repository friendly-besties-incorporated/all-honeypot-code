#!/bin/bash

if [ ! $# -eq 1 ]
then
    echo "Usage: ./get_total_apache.sh [apache output]"
    exit 1
fi

apache_total=$1

find . -name 'apache_out*' | xargs -i cat "{}" >> $apache_total
