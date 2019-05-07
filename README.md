# CaaSP-Vagrant

See your distributions instrauction for installing vagrant. You may need to consult some [distribution specific instructions to install the libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt#installation).

## Environment Variables
* CAASP_BOX_URL the url to the caasp vagrant box, defaults to http://192.168.200.13/box/caasp-3.0.box (this works in the Roseville office).

## Generating the box file
* Download caasp 3.0 openstack [qcow2](http://download.suse.de/install/SUSE-CaaSP-3-GM/SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2) file.
* Use [script](https://raw.githubusercontent.com/vagrant-libvirt/vagrant-libvirt/master/tools/create_box.sh) to generate box file.

**Note:** you can skip these step if you are in the Roseville office.

```bash
# curl -LO https://raw.githubusercontent.com/vagrant-libvirt/vagrant-libvirt/master/tools/create_box.sh
# chmod +x ./create_box.sh
# curl -LO http://download.suse.de/install/SUSE-CaaSP-3-GM/SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2
# ./create_box.sh ./SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2
# vagrant box add ./SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.box --name caasp-3.0
```

## Start Cluster

**Note:** The current provision scripts assume that there are mirrors for sles, ses and cassp running on the host system.

```bash
# vagrant plugin install vagrant-libvirt
# ./generate_config.sh
# sudo vagrant up
```