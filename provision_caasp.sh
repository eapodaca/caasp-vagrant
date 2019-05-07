#!/bin/bash

zypper ar http://192.168.121.1/caasp-3.0-updates/ caasp-update
zypper ar http://192.168.121.1/caasp-3.0-product/ caasp-product
transactional-update cleanup dup
reboot
