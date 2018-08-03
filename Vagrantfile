# -*- mode: ruby -*-

# set default values
vm_name    = 'gce4vpn'
vm_name    = ENV['vm_name'] unless ENV['vm_name'].nil?
# needed for fixing issue with different MAC on eth0 & in /etc/sysconfig/network-scripts
vm_mac     = '00155D38011B'
vm_box     = 'bento/centos-7.4'
vm_ram     = 512
no_proxy   = ENV['no_proxy']
http_proxy = ENV['http_proxy']
rsync_excl = ['.git/', '.vagrant/', '.kitchen/', '.terraform/', '.terraform.tfstate.lock', '*.tfstate']

proxy_docker_conf_dir  = '/etc/systemd/system/docker.service.d'
proxy_docker_conf_path = "#{proxy_docker_conf_dir}/30-proxy.conf"
proxy_docker_config = <<-HEREDOC
[Service]
Environment=HTTP_PROXY=#{http_proxy}
Environment=HTTPS_PROXY=#{http_proxy}
Environment=NO_PROXY=#{no_proxy}

HEREDOC

puts "Use http_proxy: '#{http_proxy}'"
puts "Use no_proxy  : '#{no_proxy}'"

# *****************************************************************************#
Vagrant.configure('2') do |config|
  # configure vagrant-proxyconf plugin
  unless http_proxy.nil?
    raise 'Install plugin vagrant-proxyconf' unless Vagrant.has_plugin?('vagrant-proxyconf')
    config.proxy.enabled  = true
    config.proxy.http     = http_proxy
    config.proxy.https    = http_proxy
    config.proxy.no_proxy = no_proxy

    config.vm.provision 'shell', inline: " \
      echo '#{proxy_docker_config}' > /home/vagrant/docker.tmp ;\
      sudo mkdir -p #{proxy_docker_conf_dir} ;\
      sudo cp /home/vagrant/docker.tmp #{proxy_docker_conf_path}"
  end

  config.vm.synced_folder '.', '/vagrant', type: 'rsync', rsync__exclude: rsync_excl
  config.vm.hostname = vm_name
  config.vm.box = vm_box
  config.vm.provision 'ansible_local' do |ansible|
    ansible.playbook = '/vagrant/gce4vpn.yml'
  end

  # for kitchen we use virtualbox backend
  config.vm.provider 'hyperv' do |h|
    h.vm_integration_services = {
      guest_service_interface: true,
      heartbeat: true,
      key_value_pair_exchange: true,
      shutdown: true,
      time_synchronization: true,
      vss: true
    }
    h.memory = vm_ram
    h.mac = vm_mac
    h.vmname = vm_name
  end
end
