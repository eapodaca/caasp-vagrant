
require 'erb'
require 'pathname'
require 'securerandom'
require 'fileutils'

clouddata_base_url = ENV['CLOUDDATA_BASE_URL'] || 'http://provo-clouddata.cloud.suse.de'
ibs_base_url = ENV['IBS_BASE_URL'] || 'http://ibs-mirror.prv.suse.net'

$update_repo = {
  caasp_product_url: ENV['CAASP_PRODUCT_URL'] || "#{ibs_base_url}/dist/ibs/SUSE/Products/SUSE-CAASP/3.0/x86_64/product/",
  caasp_update_url: ENV['CAASP_UPDATE_URL'] || "#{ibs_base_url}/dist/ibs/SUSE/Updates/SUSE-CAASP/3.0/x86_64/update/",
  sles12sp3_product_url: ENV['SLES12SP3_PRODUCT_URL'] || "#{clouddata_base_url}/repos/x86_64/SLES12-SP3-Pool/",
  sles12sp3_update_url: ENV['SLES12SP3_UPDATE_URL'] || "#{clouddata_base_url}/repos/x86_64/SLES12-SP3-Updates/",
  sles12sp3_sdk_product_url: ENV['SLES12SP3_SDK_PRODUCT_URL'] || "#{clouddata_base_url}/repos/x86_64/SLE12-SP3-SDK-Pool/",
  sles12sp3_sdk_update_url: ENV['SLES12SP3_SDK_UPDATE_URL'] || "#{clouddata_base_url}/repos/x86_64/SLE12-SP3-SDK-Updates/",
  ses_product_url: ENV['SES_PRODUCT_URL'] || "#{clouddata_base_url}/repos/x86_64/SUSE-Enterprise-Storage-5-Pool/",
  ses_update_url: ENV['SES_UPDATE_URL'] || "#{clouddata_base_url}/repos/x86_64/SUSE-Enterprise-Storage-5-Updates/"
}

base_box_repo_url = ENV['BOX_BASE_URL'] || "http://192.168.200.13/box/"
#generate box with tool from vagrant libvirt (https://github.com/vagrant-libvirt/vagrant-libvirt/blob/master/tools/create_box.sh)
# qcow file from http://download.suse.de/install/SUSE-CaaSP-3-GM/SUSE-CaaS-Platform-3.0-for-OpenStack-Cloud.x86_64-3.0.0-GM.qcow2
$boxes = {
  caasp_box_url: {
    url: ENV['CAASP_BOX_URL'] || "#{base_box_repo_url}/caasp-3.0.box",
    name: 'caasp-3.0'
  },
  sles_box_url: {
    url: ENV['SLES_BOX_URL'] || "#{base_box_repo_url}/sles12sp3.box",
    name: 'sles12sp3'
  }
}

def generate_config(vagrant_config, force=false)
  config = {}
  hosts_list = []
  num_workers = Integer(ENV['CAASP_WORKER_COUNT'] || '3')
  num_masters = Integer(ENV['CAASP_MASTER_COUNT'] || '1')
  hosts = %w{admin}
    .concat((1..num_masters).to_a.map { |n| "master-#{n}" })
    .concat((1..num_workers).to_a.map { |n| "worker-#{n}" })
    .concat(%w{ses deployer})
  ip_base = 1
  for host in hosts do
    ip_base += 1
    host_config = {
      ip: "192.168.15.#{ip_base}",
      hostname: if %w{ses deployer}.include?(host) then host else "caasp-#{host}" end
    }
    hosts_list << host_config
    config[host.to_sym] = {}.merge($update_repo).merge(host_config)
    config[host.to_sym][:type] = host unless host.include?("master") || host.include?("worker")
    config[host.to_sym][:type] = "worker" if host.include?("worker")
    config[host.to_sym][:type] = "master" if host.include?("master")
    config[host.to_sym][:name] = host
    config[host.to_sym][:admin_host] = config[:admin][:ip] if host.include?("worker") || host.include?("master")
  end
  config[:deployer][:hosts] = hosts_list

  if force || !Pathname.new(File.expand_path("../.caasp", File.dirname(__FILE__))).directory?
    generate_config_drives(config)
  end

  generate_vagrant_config(config, vagrant_config) unless vagrant_config.nil?
end

def generate_config_drive(name, **config)
  config[:public_key] = File.read(ENV['SSH_PUBLIC_KEY'] || "#{Dir.home}/.ssh/id_rsa.pub")
  config[:instance_id] = SecureRandom.uuid
  generate_cloud_config(name, 'meta-data', **config)
  generate_cloud_config(name, 'user-data', **config)
  generate_provision_script(name, **config)
  Dir.chdir(File.expand_path("../.caasp/#{name}/", File.dirname(__FILE__))) do
    system("genisoimage -o ../#{config[:hostname]}.iso -V cidata -r -J meta-data user-data > /dev/null 2>&1")
  end
end

def generate_cloud_config(name, file_type, **config)
  base_template = File.read(File.expand_path("./templates/#{file_type}.base.erb", File.dirname(__FILE__)))

  if Pathname.new(File.expand_path("./templates/#{file_type}.#{config[:type]}.erb", File.dirname(__FILE__))).file?
    type_template = File.read(File.expand_path("./templates/#{file_type}.#{config[:type]}.erb", File.dirname(__FILE__)))
    config[:specific_node_config] = ERB.new(type_template, nil, '-').result_with_hash(config)
  else
    config[:specific_node_config] = nil
  end

  config_file = ERB.new(base_template, nil, '-').result_with_hash(config)

  config_file_path = File.expand_path("../.caasp/#{name}/#{file_type}", File.dirname(__FILE__))
  system("mkdir -p #{File.dirname(config_file_path)}")

  File.write(config_file_path, config_file)
  return config_file 
end

def generate_provision_script(name, **config)
  template = File.read(File.expand_path("./provision/#{config[:type]}.sh.erb", File.dirname(__FILE__)))
  script = ERB.new(template, nil, '-').result_with_hash(config)
  File.write(File.expand_path("../.caasp/#{config[:hostname]}.sh", File.dirname(__FILE__)), script)
end

def env_var(type, name)
  ENV["#{type.upcase}_#{name.upcase}"]
end

def generate_config_drives(config)
  config.each_key do |key|
    generate_config_drive(key.to_s, config[key])
  end
end

def generate_vagrant_config(config, vagrant_config)
  config.each_key do |key|
    config_host(config[key], vagrant_config)
  end
end

$caasp_network = {
  libvirt__network_name: 'caasp',
  libvirt__network_address: '192.168.15.0',
  libvirt__forward_mode: 'none',
  libvirt__dhcp_enabled: false
}

def config_host(config, vagrant_config)
  project_root = File.expand_path("../", File.dirname(__FILE__))
  box = if %w{admin worker master}.include?(config[:type])
    $boxes[:caasp_box_url]
  else
    $boxes[:sles_box_url]
  end
  vagrant_config.vm.define config[:hostname] do |node|
    node.vm.box_url = box[:url]
    node.vm.box = box[:name]
    node.vm.synced_folder ".", "/vagrant", disabled: true
    caasp_network= {}.merge($caasp_network)
    node.vm.network :private_network,
      ip: config[:ip],
      **caasp_network
    node.vm.provision 'shell', path: "#{project_root}/.caasp/#{config[:hostname]}.sh"
    node.vm.provider :libvirt do |domain|
      domain.nested = true if config[:type] == 'worker'
      domain.memory = Integer(env_var(config[:type], 'memory') || '4096')
      domain.cpus = Integer(env_var(config[:type], 'cpu_count')  || '2')
      domain.machine_virtual_size = Integer(env_var(config[:type], 'disk_size')  || '40')
      domain.storage :file, device: :cdrom, path: "#{project_root}/.caasp/#{config[:hostname]}.iso"
      domain.storage :file, size: "#{ENV['SES_ADDTIONAL_DISK_SIZE'] || '40'}G" if config[:type] == "ses"
      domain.storage_pool_name = ENV['LIBVIRT_STORAGE_POOL'] || "default"
    end
  end
end
