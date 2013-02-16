# Update apt cache
include_recipe 'apt'

# Configure the basic system
include_recipe 'bootstrap::user'
include_recipe 'bootstrap::rvm'

node['bootstrap']['packages']['base'].each do |pkg|
  package pkg
end

# Extra packages for a specific project
# They can be added in the solo.json or Vagrantfile
node['bootstrap']['packages']['extra'].each do |pkg|
  package pkg
end

# Load optiona recipes
include_recipe 'mongodb' if node['bootstrap']['mongodb']
include_recipe 'postgresql::server' if node['bootstrap']['postgresql']
if node['bootstrap']['testing']
  include_recipe 'bootstrap::testing'
  include_recipe 'bootstrap::firefox'
end

if node['bootstrap']['java']
  node['bootstrap']['packages']['java'].each do |pkg|
    package pkg
  end
end
