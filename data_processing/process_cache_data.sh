#!/bin/bash

if [ ! $# -eq 4 ]
then
    echo "Usage: ./process_cache_data.sh [directory] [MITM output file] [commands output file] [processed files file]"
    echo "NOTE: You must run this in a directory that does NOT have a gzip file (.gz)."
    exit 1
fi

dir=$1
output_file=$2
cmds_output=$3
processed=$4

for file in $(find $dir -name '*.log.gz')
do
    if [ $(cat $processed | grep -c $file) -eq 0 ]
    then
        echo $file >> $processed

        #------------------------------------------------------------
        # MITM SESSION LOG DATA
        container=$(zcat $file| head -n 1 | cut -d" " -f3)
        attackerIP=$(zcat $file| head -n 3 | tail -n 1 | cut -d" " -f3)
        startTime=$(zcat $file | head -n 4 | tail -n 1 | cut -d" " -f3,4)

        noninteractive=$(zcat $file | grep -c "Noninteractive mode attacker command")
        if [ $noninteractive -eq 1 ]
        then
            noninteractive="y"
        else
            noninteractive="n"
        fi

        username=$(zcat $file | head -n 9 | grep "Attacker Username" | cut -d" " -f3)
        password=$(zcat $file | head -n 9 | grep "Attacker Password" | cut -d" " -f3)

        #------------------------------------------------------------

        # COMMANDS DATA

        commandsNum=0

        while read -r cmd
        do
            ((commandsNum++))
            echo "$container | $attackerIP | $startTime | $username | $password | $noninteractive | $cmd" >> $cmds_output
        done < <(zcat $file | grep -w "Noninteractive\|line" | sed 's/.*: //' | tr "['||','&&',';']" "\n" | sed '/^$/d' | sed 's/^[ ]//')


        #------------------------------------------------------------

        # MITM OUTPUT
        # Each line has data for each attacker, delimited by a | character.
        echo "$container | $attackerIP | $startTime | $username | $password | $commandsNum | $noninteractive" >> $output_file
        
        sudo mv $file /var/experiment_logs/prev_cache
    fi
done
