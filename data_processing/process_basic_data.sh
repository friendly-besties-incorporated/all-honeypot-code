#!/bin/bash

# Each time you call this script it will save a file called batch-#.data which will contain all the basic data about an attacker to a single file, divided by line.
linenum=0

for zip in $(find /var/experiment_logs -name '*.zip')
do
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
        commandsNum=$(zcat $file | grep -c @$container1)
    fi

    username=$(zcat $file | head -n 9 | grep "Attacker Username" | cut -d" " -f3)
    password=$(zcat $file | head -n 9 | grep "Attacker Password" | cut -d" " -f3)


    # Each line has data for each attacker, delimited by a | character.

    echo "$linenum | $container | $attackerIP | $startTime | $username | $password | $commandsNum" >> all_data.txt

    ((linenum++))

    rm access.log
    rm $file.gz
done
