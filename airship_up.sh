#!/bin/bash -e
vagrant up
./wait_for_deployer.sh
vagrant ssh deployer -c /home/vagrant/post-install.sh
./copy_kubeconfig.sh