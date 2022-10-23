#!/bin/bash

if [ ! $# -eq 3 ]
then
    echo "Usage: ./process_basic_data.sh [directory] [output filename] [processed files filename]"
    exit 1
fi

dir=$1
output_file=$2
processed=$3

# Each time you call this script it will save a file called batch-#.data which will contain all the basic data about an attacker to a single file, divided by line.
for zip in $(find $dir -name '*.zip')
do
    if [ $(cat $processed | grep -c $zip) -eq 0 ]
    then
        echo $zip >> $processed

        unzip $zip
        file=$(ls . | grep .gz | awk -F\.gz '{print $1}')

        container=$(zcat $file| head -n 1 | cut -d" " -f3)
        attackerIP=$(zcat $file| head -n 3 | tail -n 1 | cut -d" " -f3)
        startTime=$(zcat $file | head -n 4 | tail -n 1 | cut -d" " -f3,4)

        noninteractive=$(zcat $file | grep -c "Noninteractive mode attacker command")
        if [ $noninteractive -eq 1 ]
        then
            commandsNum=1
        else
            commandsNum=$(zcat $file | grep -c @$is-admin)
        fi

        username=$(zcat $file | head -n 9 | grep "Attacker Username" | cut -d" " -f3)
        password=$(zcat $file | head -n 9 | grep "Attacker Password" | cut -d" " -f3)

        # Each line has data for each attacker, delimited by a | character.
        echo "$container | $attackerIP | $startTime | $username | $password | $commandsNum" >> $output_file

        rm access.log
        rm $file.gz
    fi

done
