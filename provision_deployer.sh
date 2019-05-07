#!/bin/bash
if [ ! -f /firstrun ]; then
    zypper ar http://192.168.121.1/sles13sp3-product/ sles13sp3-product
    zypper ar http://192.168.121.1/sles13sp3-updates/ sles13sp3-updates

    zypper ar http://192.168.121.1/sles13sp3-sdk-product/ sles13sp3-sdk-product
    zypper ar http://192.168.121.1/sles13sp3-sdk-updates/ sles13sp3-sdk-updates

    zypper refresh
    zypper -n update

    zypper -n in git python-devel
    zypper -n in -t pattern Basis-Devel

    easy_install pip
    pip install virtualenv

    curl -sOL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    mv jq-linux64 /usr/local/bin/jq
    chmod +x /usr/local/bin/jq

    curl -sOL http://download.suse.de/ibs/SUSE:/Factory:/Head/standard/noarch/ipcalc-0.41-6.16.noarch.rpm
    zypper -n in ./ipcalc-0.41-6.16.noarch.rpms
    rm ipcalc-0.41-6.16.noarch.rpms

    cat >> /etc/hosts <<EOF
192.168.15.2 caasp-admin
192.168.15.3 caasp-master
192.168.15.4 caasp-worker-1
192.168.15.5 caasp-worker-2
192.168.15.6 caasp-worker-3
192.168.15.10 ses
EOF
  cd /home/vagrant
  sudo -u vagrant git clone --recursive https://github.com/SUSE-Cloud/socok8s

  sudo -u vagrant mkdir -p /home/vagrant/soc-workspace/inventory
  sudo -u vagrant mkdir -p /home/vagrant/soc-workspace/env

    cat >> /home/vagrant/soc-workspace/inventory/default-inventory.yml <<EOF
---
caasp-admin:
  hosts:
    caasp-admin:
  vars:
    ansible_user: root

caasp-masters:
  hosts:
    caasp-master:
  vars:
    ansible_user: root

caasp-workers:
  hosts:
    caasp-worker-1:
    caasp-worker-2:
    caasp-worker-3:
  vars:
    ansible_user: root

soc-deployer:
  hosts:
    deployer:
      ansible_connection: local
  vars:
    ansible_user: root

ses_nodes:
  hosts:
    ses:
  vars:
    ansible_user: root

airship-openstack-compute-workers:
  hosts:
    caasp-worker-3:
  vars:
    ansible_user: root

airship-openstack-control-workers:
  hosts:
    caasp-worker-1:
    caasp-worker-2:
  vars:
    ansible_user: root

airship-ucp-workers:
  hosts:
    caasp-worker-1:
    caasp-worker-2:
    caasp-worker-3:
  vars:
    ansible_user: root

airship-kube-system-workers:
  hosts:
    caasp-worker-1:
    caasp-worker-2:
    caasp-worker-3:
  vars:
    ansible_user: root
EOF

fi

touch /firstrun
vag
