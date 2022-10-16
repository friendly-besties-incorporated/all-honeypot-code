#!/bin/bash

sudo lxc-stop -n blank-t_running
sudo lxc-stop -n blank-t-2_running
sudo lxc-stop -n control-t_running
sudo lxc-stop -n it-t_running
sudo lxc-stop -n it-t-2_running
sudo lxc-stop -n pwd-t_running
sudo lxc-stop -n pwd-t-2_running
sudo lxc-stop -n swipe-t_running
sudo lxc-stop -n swipe-t-2_running

sudo lxc-destroy -n blank-t_running
sudo lxc-destroy -n blank-t-2_running
sudo lxc-destroy -n control-t_running
sudo lxc-destroy -n it-t_running
sudo lxc-destroy -n it-t-2_running
sudo lxc-destroy -n pwd-t_running
sudo lxc-destroy -n pwd-t-2_running
sudo lxc-destroy -n swipe-t_running
sudo lxc-destroy -n swipe-t-2_running

sudo pkill -9 -f serve_honeypot.sh
sudo pkill -9 -f mitm.js
