#!/bin/bash

printf "\n--CHECK SERVICES RUNNING, GENERAL--"

printf "\nCommand: sudo systemctl list-units *hpot.service"
sudo systemctl list-units *hpot.service

printf "Press enter to move on: "
read v

printf "\n\n--CHECK SERVICES RUNNING, GRANULAR--"

printf "\nCommand: sudo journalctl -u control-hpot.service | tail -30"
sudo journalctl -u control-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u blank-hpot.service | tail -30"
sudo journalctl -u blank-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u blank-2-hpot.service | tail -30"
sudo journalctl -u blank-2-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u it-hpot.service | tail -30"
sudo journalctl -u it-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u it-2-hpot.service | tail -30"
sudo journalctl -u it-2-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u pwd-hpot.service | tail -30"
sudo journalctl -u pwd-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u pwd-2-hpot.service | tail -30"
sudo journalctl -u pwd-2-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u swipe-hpot.service | tail -30"
sudo journalctl -u swipe-hpot.service | tail -10
printf "\nCommand: sudo journalctl -u swipe-2-hpot.service | tail -30"
sudo journalctl -u swipe-2-hpot.service | tail -10

printf "Press enter to move on: "
read v

printf "\n\n--CHECK EXPERIMENT LOGS--"
printf "\nCommand: cd /var/experiment_logs (shouldn't see anything)"
cd /var/experiment_logs
printf "\nCommand: du -a | cut -d/ -f2 | sort | uniq -c | sort -nr"
du -a | cut -d/ -f2 | sort | uniq -c | sort -nr
printf "\nCommand: for D in */; do ls \"$D\" -lt | head -2; done"
for D in */; do ls "$D" -lt | head -7; done

printf "Press enter to move on: "
read v

printf "\n\n--CHECK TCPDUMP LOGS--"
printf "\nCommand: cd /var/experiment_logs/tcpdump (shouldn't see anything"
cd tcpdump
printf "\nCommand: sudo systemctl status hpot-tcpdump.service"
sudo systemctl status hpot-tcpdump.service
printf "\nCommand: for D in */; do ls \"$D\" -lt | head -2; done"
for D in */; do ls "$D" -lt | head -2; done

printf "Press enter to complete: "
read v

echo "Done!"
