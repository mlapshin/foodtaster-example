def define_vm(config, name, ip)
  config.vm.define name.to_sym do |config|
    config.vm.hostname = name.to_s.gsub('_','-')
    config.vm.box = "ubuntu1204"
    config.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04.2-i386-chef-11-omnibus.box"
    config.vm.network :private_network, ip: ip

    # we don't need too much memory for our tests
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "256"]
    end

    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = %w[site-cookbooks]
    end
  end
end

Vagrant.configure("2") do |config|
  define_vm(config, :vm0, "10.0.0.100")
  define_vm(config, :vm1, "10.0.0.101")
end
