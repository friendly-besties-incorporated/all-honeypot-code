#!/bin/bash

if [ ! $# -eq 5 ]
then
    echo "Usage: ./process_basic_data.sh [directory] [MITM output file] [apache output file] [commands output file] [processed files file]"
    echo "NOTE: You must run this in a directory that does NOT have a gzip file (.gz)."
    exit 1
fi

dir=$1
output_file=$2
apache_output=$3
cmds_output=$4
processed=$5

for zip in $(find $dir -name '*.zip')
do
    if [ $(cat $processed | grep -c $zip) -eq 0 ]
    then
        echo $zip >> $processed

        unzip $zip
        file=$(ls . | grep .gz | awk -F\.gz '{print $1}')

        #------------------------------------------------------------

        # COMMANDS DATA
        commandsNum=0
        
        while read -r cmd
        do
            ((commandsNum++))
            echo "$container | $attackerIP | $startTime | $username | $password | $noninteractive | $cmd" >> $cmds_output
        done < <(zcat $file | grep -w "Noninteractive\|line" | sed 's/.*: //' | tr "['||','&&',';']" "\n" | sed '/^$/d' | sed 's/^[ ]//')

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

        # Each line has data for each attacker, delimited by a | character.
        echo "$container | $attackerIP | $startTime | $username | $password | $commandsNum | $noninteractive" >> $output_file

        #------------------------------------------------------------

        # APACHE ACCESS LOG DATA
        # Only add a line if the access log is non-empty.
        if [ $(wc -l < access.log) -ge 1 ]
        then
            while read -r line
            do
                apacheIP=$(echo $line | cut -d' ' -f1)
                apacheTime=$(echo $line | cut -d'[' -f2 | cut -d']' -f1 | cut -d' ' -f1)
                apacheGET=$(echo $line | cut -d'"' -f2)
                apacheSMTH=$(echo $line | cut -d'"' -f4)
                apacheID=$(echo $line | cut -d'"' -f6)
                if [[ $(echo "$apacheGET" | grep -c GET) -eq 1 ]]
                then
                    isGet="y"
                else
                    isGet="n"
                fi

            done < access.log

            echo "$container | $apacheIP | $apacheTime | $apacheGET | $apacheSMTH | $apacheID | $isGet" >> $apache_output
        fi
        
        #------------------------------------------------------------
        
        rm access.log
        rm $file.gz

    fi
done
