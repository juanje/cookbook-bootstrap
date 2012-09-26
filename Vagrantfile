def local_cache(box_name)
  cache_dir = File.join(File.expand_path(Vagrant::Environment::DEFAULT_HOME),
                        'cache',
                        'apt',
                        box_name)
  partial_dir = File.join(cache_dir, 'partial')
  FileUtils.mkdir_p(partial_dir) unless File.exists? partial_dir
  cache_dir
end


Vagrant::Config.run do |config|
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
  cache_dir = local_cache(config.vm.box)

  config.vm.share_folder "v-cache",
                         "/var/cache/apt/archives/",
                         cache_dir

  config.vm.host_name = "project" 

  config.vm.network :hostonly, "192.168.122.61"

  config.vm.provision :shell, :inline => "/opt/chef/embedded/bin/gem search -i chef -v 10.14.2 || sudo /opt/chef/embedded/bin/gem install chef -v 10.14.2 --no-rdoc --no-ri"

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug if ENV['DEBUG']

    chef.run_list = [
      "recipe[aentos-bootstrap]"
    ]
  end
end
