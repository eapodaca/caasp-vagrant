file_path = File.dirname(__FILE__)
caasp_box_url = ENV['CAASP_BOX_URL'] || "http://192.168.200.13/box/caasp-3.0.box"
#generate box with tool from vagrant libvirt (https://github.com/vagrant-libvirt/vagrant-libvirt/blob/master/tools/create_box.sh)
# qcow file from http://download.suse.de/install/SUSE-CaaSP-3-GM/SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.socket = "/var/run/libvirt/libvirt-sock"
  end
  config.vm.define :admin do |node|
    node.vm.box_url = caasp_box_url
    node.vm.box = "caasp-3.0"
    node.vm.synced_folder ".", "/vagrant", disabled: true
    # node.vm.network :private_network,
    #   :libvirt__network_name => 'caasp',
    #   :type => 'dhcp',
    #   :libvirt__network_address => '192.168.15.0',
    #   :libvirt__forward_mode => 'none', :libvirt__dhcp_enabled => false
    node.vm.provider :libvirt do |domain|
      domain.memory = 4096
      domain.cpus = 2
      domain.storage :file, :device => :cdrom, :path => "#{file_path}/.caasp/admin.iso"
      domain.storage_pool_name = "ssd"
    end
  end
  config.vm.define :master do |node|
    node.vm.box_url = caasp_box_url
    node.vm.box = "caasp-3.0"
    node.vm.synced_folder ".", "/vagrant", disabled: true
    # node.vm.network :private_network,
    #   :libvirt__network_name => 'caasp',
    #   :type => 'dhcp',
    #   :libvirt__network_address => '192.168.15.0',
    #   :libvirt__forward_mode => 'none', :libvirt__dhcp_enabled => false
    node.vm.provider :libvirt do |domain|
      domain.memory = 4096
      domain.cpus = 4
      domain.storage :file, :device => :cdrom, :path => "#{file_path}/.caasp/node.iso"
      domain.storage_pool_name = "ssd"
    end
  end
  (1..3).to_a.each do |node_number|
    config.vm.define "worker-#{node_number}".to_sym do |node|
      node.vm.box_url = caasp_box_url
      node.vm.box = "caasp-3.0"
      node.vm.synced_folder ".", "/vagrant", disabled: true
      # node.vm.network :private_network,
      #   :libvirt__network_name => 'caasp',
      #   :type => 'dhcp',
      #   :libvirt__network_address => '192.168.15.0',
      #   :libvirt__forward_mode => 'none', :libvirt__dhcp_enabled => false
      node.vm.provider :libvirt do |domain|
        domain.nested = true
        domain.memory = 4096
        domain.cpus = 4
        domain.storage :file, :device => :cdrom, :path => "#{file_path}/.caasp/node.iso"
        domain.storage_pool_name = "ssd"
      end
    end
  end
end