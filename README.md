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
|OPENSUSE_DEVEL_TOOLS_URL|`${$OPENSUSE_MIRROR}/repositories/devel:/tools/openSUSE_Leap_15.0/`||


## Generating the box file
### **Note:** you can skip these step if you are in the Roseville office.
```bash
./create_boxes.sh
```

## Start Cluster

```bash
# vagrant up
```

## Steps after VMs are up
### Trigger the post up steps:
```bash
vagrant ssh deployer -c /home/vagrant/post-install.sh
```
This will perform the following:
1. Bootstrap the caasp cluster
2. retreive kubectl config
3. Deploy SES
4. Label nodes for OpenStack
5. Deploy openstack via airship
