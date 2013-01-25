# We need to create and configure the aentos user before to install RVM
include_recipe 'bootstrap::user'

# Update apt cache
include_recipe 'apt'

# Install and configure databases
include_recipe 'mongodb'
include_recipe 'postgresql::server'

# Install and configure RVM
include_recipe 'bootstrap::rvm'

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
