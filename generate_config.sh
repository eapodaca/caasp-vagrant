#!/bin/bash
rm -rf ./.caasp/

hosts=( admin master worker-1 worker-2 worker-3 )

public_key=$(cat ~/.ssh/id_rsa.pub)

for index in "${!hosts[@]}"
do
   : 
   host=${hosts[$index]}
   mkdir -p ./.caasp/$host

   INSANCE_ID=$(uuidgen)
   ip=$((index+2))

   cat > ./.caasp/$host/meta-data <<EOF
instance-id: ${INSANCE_ID}
local-hostname: caasp-${host}
hostname: caasp-${host}
public-keys:
  - ${public_key}
EOF

     cat > ./.caasp/$host/user-data <<EOF
#cloud-config
disable_root: False
ssh_deletekeys: False
ssh_pwauth: True
zypp_repos:
  "caasp-pool":
    baseurl: http://ibs-mirror.prv.suse.net/dist/ibs/SUSE/Products/SUSE-CAASP/3.0/x86_64/product/
  "caasp-updates":
    baseurl: http://ibs-mirror.prv.suse.net/dist/ibs/SUSE/Updates/SUSE-CAASP/3.0/x86_64/update/
users:
  - name: vagrant
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${public_key}
      - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOF

  if [ "$host" == "admin" ]; then

     cat >> ./.caasp/$host/user-data <<EOF
suse_caasp:
  role: admin
EOF
  else
     cat >> ./.caasp/$host/user-data <<EOF
suse_caasp:
  role: cluster
  admin_node: 192.168.121.197
EOF
  fi


  cd ./.caasp/${host}
  genisoimage -o ../${host}.iso -V cidata -r -J meta-data user-data > /dev/null 2>&1
  cd - > /dev/null 2>&1
  rm -rf ./.caasp/${host}

done



