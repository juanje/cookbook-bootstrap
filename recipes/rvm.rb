# Some handy vars
user_home = "/home/#{node['bootstrap']['user']}"
rvm_src_path = "#{user_home}/.rvm/src"
user_env = {
  'USER' => node['bootstrap']['user'],
  'HOME' => user_home
}


node['bootstrap']['rvm']['packages'].each do |pkg|
  package pkg
end

execute "Install rvm" do
  command "curl -L #{node['bootstrap']['rvm']['installer_url']} | bash -s #{node['bootstrap']['rvm']['branch']}"
  user node['bootstrap']['user']
  cwd  user_home
  environment user_env
  creates "#{user_home}/.rvm/scripts/rvm"
end

bash "Install ruby #{node['bootstrap']['rvm']['ruby']}" do
  code "source $HOME/.rvm/scripts/rvm ; rvm install #{node['bootstrap']['rvm']['ruby']}"
  user node['bootstrap']['user']
  cwd  user_home
  environment user_env
  creates "#{user_home}/.rvm/rubies/#{node['rvm']['ruby']}/config"
  subscribes :run, resources(:execute => "Install rvm")
end

execute "remove rvm sources" do
  command "rm -fr #{rvm_src_path}/*"
  only_if { ::File.exists? "#{rvm_src_path}/rvm" }
  subscribes :run, resources(:bash => "Install ruby #{node['bootstrap']['rvm']['ruby']}")
end
