require 'berkshelf/vagrant'
require 'json'

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
  config.vm.box = "opscode-ubuntu-12.04-i386.box"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04-i386.box"
  cache_dir = local_cache(config.vm.box)

  config.vm.share_folder "v-cache",
                         "/var/cache/apt/archives/",
                         cache_dir

  config.vm.host_name = "project" 

  config.vm.network :hostonly, "192.168.122.61"

  config.vm.provision :shell, :inline => "/opt/chef/embedded/bin/gem search -i chef -v 10.16.2 || sudo /opt/chef/embedded/bin/gem install chef -v 10.16.2 --no-rdoc --no-ri"

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug if ENV['DEBUG']
    # Default run_list
    run_list = [ "recipe[bootstrap]" ]

    # Load solo.json config if it exists
    if File.exists? 'solo.json'
      json = JSON.load(IO.read('solo.json'))

      # solo.json could contain a run_list. We need to remove it from the json config
      # and put its value as the new run_list
      run_list = json.delete 'run_list' if json.include? 'run_list'

      chef.json = json
    end
    chef.run_list = run_list
  end
end
