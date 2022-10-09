This folder contains all code for the creation and deletion of active honeypots.

### start_all_honeypots
Runs serve_honeypot 4 times. Modify the code of this file to change configurations.

### serve_honeypot
A continuously running script that recycles honeypots based on MITM sessions.

### nat_rules
Called by main_script to create and delete NAT rules.

### process_complete_container
Processes a container that has been completed.
