node['bootstrap']['rvm']['packages'].each do |pkg|
  package pkg
end

execute "Install rvm" do
  command "curl -L #{node['bootstrap']['rvm']['installer_url']} | bash -s #{node['bootstrap']['rvm']['branch']}"
  user node['user_name']
  cwd  node['user_home']
  environment node['user_env']
  creates "#{node['user_home']}/.rvm/scripts/rvm"
end

bash "Install ruby #{node['bootstrap']['rvm']['ruby']}" do
  code "source $HOME/.rvm/scripts/rvm ; rvm install #{node['bootstrap']['rvm']['ruby']}"
  user node['user_name']
  cwd  node['user_home']
  environment node['user_env']
  creates "#{node['user_home']}/.rvm/rubies/#{node['bootstrap']['rvm']['ruby']}/config"
  subscribes :run, resources(:execute => "Install rvm")
end

if node['bootstrap']['rvm']['clean_sources']
  rvm_src_path = "#{node['user_home']}/.rvm/src"
  execute "remove rvm sources" do
    command "rm -fr #{rvm_src_path}/*"
    only_if { ::File.exists? "#{rvm_src_path}/rvm" }
    subscribes :run, resources(:bash => "Install ruby #{node['bootstrap']['rvm']['ruby']}")
  end
end

# Create a .gemrc for the aentos user
file "#{node['user_home']}/.gemrc" do
  content node['bootstrap']['gem_options']
  owner  node['user_name']
  group  node['user_name']
  mode   0644
  action :create_if_missing
end
