#!/bin/bash

if [ ! $# -eq 2 ]
then
        echo "Usage: ./get_cmd_count [path to session log (without .gz)] [command]"
        exit 1
fi


# Returns the number of times a certain command has been tried in a given session log.

log=$1
cmd=$2
container=$(zcat $log | head -n 1 | cut -d" " -f3)

zcat $log | grep $container | sed "s/.*$ //g" | grep -w -c $cmd
