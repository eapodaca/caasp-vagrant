file_path = File.dirname(__FILE__)

require_relative('./lib/generate_config')

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.socket = "/var/run/libvirt/libvirt-sock"
  end
  generate_config(config)

  # This does not get triggered after all provision steps
  # config.trigger.after :provision do |trigger|
  #   trigger.run = {inline: "vagrant ssh deployer -c /home/vagrant/post-install.sh"}
  # end
end
