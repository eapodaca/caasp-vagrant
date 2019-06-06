#!/bin/bash -e
vagrant ssh-config > ./.vagrant/ssh-config
echo -n "Waiting for deployer to reboot "
while ! ssh -F .vagrant/ssh-config -o ConnectTimeout=5 deployer 'echo "OK"'
do
    echo -n "."
    sleep 1
done
echo ''
