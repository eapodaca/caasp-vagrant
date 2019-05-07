#!/bin/bash

zypper ar http://192.168.121.1/sles13sp3-product/ sles13sp3-product
zypper ar http://192.168.121.1/sles13sp3-updates/ sles13sp3-updates
zypper ar http://192.168.121.1/ses-5-product/ ses-5-product
zypper ar http://192.168.121.1/ses-5-updates/ ses-5-updates
zypper refresh
zypper -n update
zypper -n in -t pattern ceph_server
reboot
