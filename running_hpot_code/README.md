This folder contains all code for the creation and deletion of active honeypots.

### start_all_honeypots
Runs main_script 4 times. Modify the code of this file to change configurations.

### main_script
A continuously running script that recycles honeypots based on MITM+broken pipe. 

### nat_rules
Called by main_script to create and delete NAT rules.

### process_complete_container
Processes a container that has been completed.
