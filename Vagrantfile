require 'yaml'

Vagrant.require_version '>= 2.0.1'
vagrant_root = File.dirname(__FILE__)

required_plugins = ['vagrant-hosts']
required_plugins.each do |plugin|
  raise "Run \'vagrant plugin install #{plugin}\'" unless Vagrant.has_plugin? plugin
end

environment = YAML.load_file("#{vagrant_root}/environment.yaml")
nodes = environment['nodes']
config = environment['config']

network_prefix = config['network_prefix']
domain = config['domain']

Vagrant.configure('2') do |config|

  nodes.each_with_index do |(node, data), index|
    config.vm.define node do |n|

      network_address = "#{network_prefix}.#{index + 100}"
      # n.vm.synced_folder '.', '/vagrant', type: "sshfs"

      n.vm.provider 'virtualbox' do |v|
        v.customize ['modifyvm', :id, '--ioapic', 'on']
        v.customize ['modifyvm', :id, '--audio', 'none']
        v.memory = data['memory']
        v.cpus = data['cpus']
      end

      n.vm.box = data['box']
      n.vm.network :private_network, ip: "#{network_prefix}.#{index + 100}"
      n.vm.hostname = "#{node}.#{domain}"

    end
  end
end