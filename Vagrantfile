file_path = File.dirname(__FILE__)
base_box_repo_url = ENV['BOX_BASE_URL'] || "http://192.168.200.13/box/"
caasp_box_url = ENV['CAASP_BOX_URL'] || "#{base_box_repo_url}/caasp-3.0.box"
sles_box_url = ENV['SLES_BOX_URL'] || "#{base_box_repo_url}/sles12sp3.box"
#generate box with tool from vagrant libvirt (https://github.com/vagrant-libvirt/vagrant-libvirt/blob/master/tools/create_box.sh)
# qcow file from http://download.suse.de/install/SUSE-CaaSP-3-GM/SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2

caasp_network = {
  libvirt__network_name: 'caasp',
  libvirt__network_address: '192.168.15.0',
  libvirt__forward_mode: 'none',
  libvirt__dhcp_enabled: false
}

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.socket = "/var/run/libvirt/libvirt-sock"
  end
  config.vm.define :admin do |node|
    node.vm.box_url = caasp_box_url
    node.vm.box = "caasp-3.0"
    node.vm.synced_folder ".", "/vagrant", disabled: true
    node.vm.provision "shell", path: "provision_caasp.sh"
    node.vm.network :private_network,
      ip: '192.168.15.2',
      **caasp_network
    node.vm.provider :libvirt do |domain|
      domain.memory = 4096
      domain.cpus = 2
      domain.storage :file, device: :cdrom, path: "#{file_path}/.caasp/caasp-admin.iso"
      domain.storage_pool_name = "ssd"
    end
  end
  config.vm.define :master do |node|
    node.vm.box_url = caasp_box_url
    node.vm.box = "caasp-3.0"
    node.vm.synced_folder ".", "/vagrant", disabled: true
    node.vm.provision "shell", path: "provision_caasp.sh"
    node.vm.network :private_network,
      ip: '192.168.15.3',
      **caasp_network
    node.vm.provider :libvirt do |domain|
      domain.memory = 4096
      domain.cpus = 4
      domain.storage :file, device: :cdrom, path: "#{file_path}/.caasp/caasp-master.iso"
      domain.storage_pool_name = "ssd"
    end
  end
  config.vm.define :ses do |node|
    node.vm.box_url = sles_box_url
    node.vm.box = "sles12sp3"
    node.vm.synced_folder ".", "/vagrant", disabled: true
    node.vm.provision "shell", path: "provision_ses.sh"
    node.vm.network :private_network,
      ip: '192.168.15.10',
      **caasp_network
    node.vm.provider :libvirt do |domain|
      domain.memory = 4096
      domain.cpus = 2
      domain.machine_virtual_size = 40
      domain.storage :file, device: :cdrom, path: "#{file_path}/.caasp/ses.iso"
      domain.storage_pool_name = "ssd"
      domain.storage :file, size: '40G'
    end
  end
  config.vm.define :deployer do |node|
    node.vm.box_url = opensuse_box_url
    node.vm.box = "sles12sp3"
    node.vm.synced_folder ".", "/vagrant", disabled: true
    node.vm.provision "shell", path: "provision_deployer.sh"
    node.vm.network :private_network,
      ip: '192.168.15.15',
      **caasp_network
    node.vm.provider :libvirt do |domain|
      domain.memory = 2048
      domain.cpus = 2
      domain.machine_virtual_size = 40
      domain.storage :file, device: :cdrom, path: "#{file_path}/.caasp/deployer.iso"
      domain.storage_pool_name = "ssd"
    end
  end
  (1..3).to_a.each do |node_number|
    config.vm.define "worker-#{node_number}".to_sym do |node|
      node.vm.box_url = caasp_box_url
      node.vm.box = "caasp-3.0"
      node.vm.synced_folder ".", "/vagrant", disabled: true
      node.vm.provision "shell", path: "provision_caasp.sh"
      node.vm.network :private_network,
        ip: "192.168.15.#{node_number + 3}",
        **caasp_network
      node.vm.provider :libvirt do |domain|
        domain.nested = true
        domain.memory = 4096
        domain.cpus = 4
        domain.storage :file, device: :cdrom, path: "#{file_path}/.caasp/caasp-worker-#{node_number}.iso"
        domain.storage_pool_name = "ssd"
      end
    end
  end
end
