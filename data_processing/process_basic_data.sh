#!/bin/bash

# Each time you call this script it will save a file called batch-#.data which will contain all the basic data about an attacker to a single file, divided by line.
# This part determines what the new file name for the processed data will be called as to not overwrite existing files. 
linenum=0
filename="batch"
i=1
if [[ -e ../backup_mitm_logs/data/$filename-$i.data ]]
then
  while [[ -e ../backup_mitm_logs/data/$filename-$i.data ]]
  do
    let i++
  done
fi
filename="$filename-$i"

# Looks at each .gz file in the session_streams folder of the MITM server and extracts basic data about an attacker to create a line of information.
for file in ../MITM/logs/session_streams/*.gz
do
  ((linenum++))
  container=$(zcat $file| head -n 1 | cut -d" " -f3)
  attackerIP=$(zcat $file| head -n 3 | tail -n 1 | cut -d" " -f3)
  startTime=$(zcat $file | head -n 4 | tail -n 1 | cut -d" " -f3,4)
  endTime=$(zcat $file| tail -n 1 | cut -d" " -f 1,2 | sed 's/.$//')
  commandsNum=$(zcat $file | grep -c @$container1)
  difference=$(( $(date -d "$endTime" "+%s" ) - $(date -d "$startTime" "+%s") ))
  minutes=$((difference/60))

# Each line has data for each attacker, delimited by a | character.
  echo "$linenum | $container | $attackerIP | $startTime | $endTime | $commandsNum | $minutes" >> ../backup_mitm_logs/data/$filename.data
done

# A message indicating that the processing was finished as well as what file it was saved to.
echo "File saved to all-honeypot-code/MITM/backup_mitm_logs/data/$filename.data"
