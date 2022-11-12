#!/bin/bash

cd blank-t
./process_apache_data.sh /var/experiment_logs/blank-t apache_out1 pr1 &
cd ..

cd blank-t-2
./process_apache_data.sh /var/experiment_logs/blank-t-2 apache_out2 pr2 &
cd ..

cd it-t
./process_apache_data.sh /var/experiment_logs/it-t apache_out6 pr6 &
cd ..

cd it-t-2
./process_apache_data.sh /var/experiment_logs/it-t-2 apache_out7 pr7 &
cd ..

cd pwd-t
./process_apache_data.sh /var/experiment_logs/pwd-t apache_out8 pr8 &
cd ..

cd pwd-t-2
./process_apache_data.sh /var/experiment_logs/pwd-t-2 apache_out9 pr9 &
cd ..

cd swipe-t
./process_apache_data.sh /var/experiment_logs/swipe-t apache_out10 pr10 &
cd ..

cd swipe-t-2
./process_apache_data.sh /var/experiment_logs/swipe-t-2 apache_out11 pr11 &
cd ..
