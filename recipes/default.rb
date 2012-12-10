# Some handy vars
rvm_src_path = "/home/#{node['bootstrap']['user']}/.rvm/src"

# Set some RVM attributes
node.set['rvm']['user_installs'] = [ {'user' => node['bootstrap']['user']} ]
node.set['rvm']['user_default_ruby'] = node['bootstrap']['default_ruby']
node.set['rvm']['user_rubies'] = node['bootstrap']['rubies']

# We need to create and configure the aentos user before to install RVM
include_recipe 'bootstrap::user'

# Update apt cache
include_recipe 'apt'

# Install and configure databases
include_recipe 'mongodb'
include_recipe 'postgresql::server'

# Install and configure RVM
include_recipe 'rvm::user'

execute "remove rvm sources" do
  command "rm -fr #{rvm_src_path}/*"
  only_if { ::File.exists? "#{rvm_src_path}/rvm" }
end

# Install extra packages
node['bootstrap']['packages'].each do |pkg|
  package pkg
end

# Add services to connect remotely with the X session
node['bootstrap']['init_scripts'].each do |script|
  service script do
    supports :status => true, :start => true, :stop => true
  end

  template "/etc/init.d/#{script}" do
    source   "#{script}.erb"
    mode     '0755'
    notifies :enable, "service[#{script}]"
    notifies :start, "service[#{script}]"
  end
end
