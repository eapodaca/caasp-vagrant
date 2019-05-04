#!/bin/bash
sudo zypper ar http://192.168.200.13/caasp/3.0/update/ caasp-update
sudo zypper ar http://192.168.200.13/caasp/3.0/product/ caasp-product
sudo transactional-update cleanup dup
sudo reboot

