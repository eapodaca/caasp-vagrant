#!/bin/bash

vagrant ssh-config > .vagrant/ssh-config

ssh -F .vagrant/ssh-config deployer /home/vagrant/copy_kubernetes_config.sh

scp -F .vagrant/ssh-config -r deployer:/home/vagrant/.kube .caasp/kube
