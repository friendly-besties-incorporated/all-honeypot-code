# all-honeypot-code
This is where we'll put completed versions of our honeypot code.

# Please update this readme if you change the structure or add big things into folders

## Not yet placed anywhere:
1. Cron jobs that check up on running hpots
2. Cron jobs that backup MITM logs

## running-hpot-code
This is all code for actually running the experiment. This contains creating copies of containers, creating nap rules, creating MITM, killing when MITM completes, etc.
Lots of things incomplete here, the biggest of which being the MITM logs are not backed up anywhere at the moment.

## template-creation
All code for creating the templates that are then copied in running-hpot-code. Includes adding honey, poisoning wget and curl, installing and starting apache.

## data-processing
Code for processing the data! Currently empty.

## mirrored-websites
The mirrored websites. Currently, DIT info page and DID change password page.
