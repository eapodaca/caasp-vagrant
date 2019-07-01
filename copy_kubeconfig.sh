#!/bin/bash
rm -rf .caasp/kube
vagrant ssh-config > .vagrant/ssh-config

ssh -F .vagrant/ssh-config deployer /home/vagrant/copy_kubernetes_config.sh

scp -F .vagrant/ssh-config -r deployer:/home/vagrant/.kube .caasp/kube

master_ip=`grep -A1 'Host caasp-master-1' .vagrant/ssh-config | grep HostName | awk '{ print $2 }'`

client_cert=`base64 .caasp/kube/kubectl-client-cert.crt -w 0`
client_key=`base64 .caasp/kube/kubectl-client-cert.key -w 0`

sed -i 's/\/home\/vagrant\/.kube\///' .caasp/kube/config
sed -i "s/caasp-master-1/${master_ip}/" .caasp/kube/config

sed -i "s/^\s*certificate-authority:.*$/    insecure-skip-tls-verify: true/m" .caasp/kube/config
sed -i "s/^\s*client-certificate:.*$/    client-certificate-data: ${client_cert}/m" .caasp/kube/config
sed -i "s/^\s*client-key:.*$/    client-key-data: ${client_key}/m" .caasp/kube/config
