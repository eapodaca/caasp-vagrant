#!/bin/bash -e
export ENABLE_SES=0
vagrant up
./wait_for_deployer.sh
vagrant ssh deployer -c /home/vagrant/caasp-bootstrap.sh
