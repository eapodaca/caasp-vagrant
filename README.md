# CaaSP-Vagrant

## What is this?

Some ruby code and shell scripts to quickly setup a CaaSP cluster (k8s) using vagrant and libvirt. Under the covers this uses cloudinit config files to create vagrant users and configure CaaSP node roles.

## Why?

Because it was really teadious and time intensive to set these up over and over manually.

# Setup

See your distributions instrauction for installing vagrant. You may need to consult some [distribution specific instructions to install the libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt#installation).

On openSUSE a repo needs to be added for vagrant:

```bash
sudo zypper ar https://download.opensuse.org/repositories/Virtualization:/vagrant/openSUSE_Leap_15.0/ vagrant
sudo zypper in vagrant vagrant-libvirt
vagrant plugin install vagrant-libvirt
```

Edit the `/etc/libvirt/libvirtd.conf` file to allow admin users access to libvirt unix socket. Be sure to add yourself to the group you choose.

```
unix_sock_group = "wheel"
unix_sock_ro_perms = "0770"
unix_sock_rw_perms = "0770"
unix_sock_admin_perms = "0770"

auth_unix_ro = "none"
auth_unix_rw = "none"
```

## Environment Variables

These can be written in a `.local.env` file and they will automatically be loaded when `vagrant up` is triggered.

|Variable|Default|Description|
|--------|-------|-----------|
|SSH_PUBLIC_KEY|`~/.ssh/id_rsa.pub`|The path to your ssh public key|
|BOX_BASE_URL|`http://192.168.200.13`||
|CAASP_BOX_URL|`${BOX_BASE_URL}/box/caasp-3.0.box`|The url to the caasp vagrant box|
|SLES_BOX_URL|`${BOX_BASE_URL}/box/sles12sp3.box`|The url to the caasp vagrant box|
|LIBVIRT_STORAGE_POOL|`default`|The libvirt storage pool where images will be stored|
|CAASP_WORKER_COUNT|`3`|The interger number if caasp worker nodes that should be deployed|
|CAASP_MASTER_COUNT|`1`|The interger number if caasp master nodes that should be deployed|
|ADMIN_CPU_COUNT|`2`|The integer count of CPU cores for caasp admin node|
|ADMIN_MEMORY|`4096`|The integer count in MB of memory for caasp admin node|
|ADMIN_DISK_SIZE|`40`|The integer count in GB of disk size for caasp admin node|
|MASTER_CPU_COUNT|`4`|The integer count of CPU cores for caasp master node|
|MASTER_MEMORY|`4096`|The integer count in MB of memory for caasp master node|
|MASTER_DISK_SIZE|`40`|The integer count in GB of disk size for caasp master node|
|WORKER_CPU_COUNT|`4`|The integer count of CPU cores for caasp worker nodes|
|WORKER_MEMORY|`4096`|The integer count in MB of memory for caasp wokrer nodes|
|WORKER_DISK_SIZE|`40`|The integer count in GB of disk size for caasp worker nodes|
|SES_CPU_COUNT|`2`|The integer count of CPU cores for ses node|
|SES_MEMORY|`4096`|The integer count in MB of memory for ses node|
|SES_DISK_SIZE|`40`|The integer count in GB of disk size for ses node|
|SES_ADDTIONAL_DISK_SIZE|`40`|The integer count in GB of disk size for ses node|
|DEPLOYER_CPU_COUNT|`2`|The integer count of CPU cores for deployer node|
|DEPLOYER_MEMORY|`2048`|The integer count in MB of memory for deployer node|
|DEPLOYER_DISK_SIZE|`40`|The integer count in GB of disk size for deployer node|
|CLOUDDATA_BASE_URL|`http://provo-clouddata.cloud.suse.de`||
|IBS_BASE_URL|`http://ibs-mirror.prv.suse.net`||
|OPENSUSE_MIRROR|`http://download.opensuse.org/`||
|CAASP_PRODUCT_URL|`http://${IBS_BASE_URL}/dist/ibs/SUSE/Products/SUSE-CAASP/3.0/x86_64/product/`||
|CAASP_UPDATE_URL|`http://${IBS_BASE_URL}/dist/ibs/SUSE/Updates/SUSE-CAASP/3.0/x86_64/update/`||
|SLES12SP3_PRODUCT_URL|`${CLOUDDATA_BASE_URL}/repos/x86_64/SLES12-SP3-Pool/`||
|SLES12SP3_UPDATE_URL|`${CLOUDDATA_BASE_URL}/repos/x86_64/SLES12-SP3-Updates/`||
|SLES12SP3_SDK_PRODUCT_URL|`${CLOUDDATA_BASE_URL}/repos/x86_64/SLE12-SP3-SDK-Pool/`||
|SLES12SP3_SDK_UPDATE_URL|`${CLOUDDATA_BASE_URL}/repos/x86_64/SLE12-SP3-SDK-Updates/`||
|SES_PRODUCT_URL|`${CLOUDDATA_BASE_URL}/repos/x86_64/SUSE-Enterprise-Storage-5-Pool/`||
|SES_UPDATE_URL|`${CLOUDDATA_BASE_URL}/repos/x86_64/SUSE-Enterprise-Storage-5-Updates/`||
|OPENSUSE_OSS_URL|`${OPENSUSE_MIRROR}/distribution/leap/15.0/repo/oss/"`||
|OPENSUSE_NONOSS_URL|`${OPENSUSE_MIRROR}/distribution/leap/15.0/repo/non-oss/"`||
|OPENSUSE_UPDATES_OSS_URL|`${OPENSUSE_MIRROR}/update/leap/15.0/oss/"`||
|OPENSUSE_UPDATES_NONOSS_URL|`${OPENSUSE_MIRROR}/update/leap/15.0/non-oss/`||


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
#
# curl -LO http://download.suse.de/install/SLE-12-SP3-JeOS-GM/SLES12-SP3-JeOS-for-OpenStack-Cloud.x86_64-GM.qcow2
# ./create_box.sh ./SLES12-SP3-JeOS-for-OpenStack-Cloud.x86_64-GM.qcow2
# vagrant box add ./SLES12-SP3-JeOS-for-OpenStack-Cloud.x86_64-GM.box --name sles12sp3
```

## Start Cluster

```bash
# vagrant plugin install vagrant-libvirt
# sudo vagrant up
```

### If config changes force config regen

```bash
# ./generate_config.sh
```

## Steps after VMs are up

1. Update `/etc/hosts` on host os to point to `cassp-admin` and `caasp-master-1`
```
<caasp-admin-eth0-ip>     caasp-admin
<caasp-master-1-eth0-ip>  caasp-master-1
```
2. Go to [http://caasp-admin/](http://caasp-admin/) to complete the bootstrap process.
3. Copy kubeconfig
```bash
vagrant ssh-config > ~/.ssh/v-config
alias vssh='ssh -F ~/.ssh/v-config'
vssh deployer
> ./copy_kubernetes_config.sh
```
4. Verify that kubectl command can talk to k8s api on master nodes.
```bash
vssh deployer
kubectl get nodes
```
7. Run SES setup step from socok8s repo on the `deployer` nodes. This step may have to be run multiple times.
```bash
cd ~/socok8s/
./run.sh deploy_ses
```
8. Run openstack deployment
```bash
./run.sh setup_caasp_workers_for_openstack
./run.sh deploy
```
Or without airship, with `OpenStack-Helm`:
```bash
./run.sh setup_caasp_workers_for_openstack
./run.sh deploy_osh
```
