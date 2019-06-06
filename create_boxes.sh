#!/bin/bash
temp_dir=$(mktemp -d)

mkdir -p $temp_dir

cd $temp_dir
curl -LO https://raw.githubusercontent.com/vagrant-libvirt/vagrant-libvirt/master/tools/create_box.sh
chmod +x ./create_box.sh
curl -LO http://download.suse.de/install/SUSE-CaaSP-3-GM/SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2
./create_box.sh ./SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2
vagrant box add ./SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.box --name caasp-3.0

curl -LO http://download.suse.de/install/SLE-12-SP3-JeOS-GM/SLES12-SP3-JeOS-for-OpenStack-Cloud.x86_64-GM.qcow2
./create_box.sh ./SLES12-SP3-JeOS-for-OpenStack-Cloud.x86_64-GM.qcow2
vagrant box add ./SLES12-SP3-JeOS-for-OpenStack-Cloud.x86_64-GM.box --name sles12sp3

curl -LO https://download.opensuse.org/distribution/leap/15.0/jeos/openSUSE-Leap-15.0-JeOS.x86_64-15.0.1-OpenStack-Cloud-Current.qcow2
./create_box.sh ./openSUSE-Leap-15.0-JeOS.x86_64-15.0.1-OpenStack-Cloud-Current.qcow2
vagrant box add ./openSUSE-Leap-15.0-JeOS.x86_64-15.0.1-OpenStack-Cloud-Current.box --name opensuse15
cd -
rm -rf $tmp_dir
