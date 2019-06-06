file_path = File.dirname(__FILE__)

require_relative('./lib/generate_config')

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.socket = "/var/run/libvirt/libvirt-sock"
  end
  generate_config(config)
end
