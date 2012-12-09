require 'berkshelf/vagrant'

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
  config.vm.box = "ubuntu-12.04-nfs-i386"
  config.vm.box_url = "http://github.com/downloads/juanje/bento/ubuntu-12.04-nfs-i386.box"

  cache_dir = local_cache(config.vm.box)
  config.vm.share_folder "v-cache", "/var/cache/apt/archives/", cache_dir, :nfs => true

  config.vm.share_folder "v-code", "/vagrant-nfs", "../", :nfs => true
  config.bindfs.bind_folder "/vagrant-nfs", "/mnt/code/"

  config.vm.network :hostonly, "33.33.33.10"

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug if ENV['DEBUG']

    chef.nfs = true

    chef.run_list = [
      "recipe[aentos-bootstrap]"
    ]
  end
end
