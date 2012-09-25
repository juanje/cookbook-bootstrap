# Some handy vars
user_home = "/home/#{node['bootstrap']['user']}"
user_gemrc = "#{user_home}/.gemrc"

# Create the aentos user
user node['bootstrap']['user'] do
  uid      node['bootstrap']['uid']
  gid      node['bootstrap']['gid']
  home     user_home
  shell    node['bootstrap']['shell']
  password node['bootstrap']['password']
  supports :manage_home => true
end

# Add the aentos user to the sudoers with NOPASSWD
sudo node['bootstrap']['user'] do
  user node['bootstrap']['user']
  commands [ "ALL" ]
  nopasswd true
end

# Create a .gemrc for the aentos user
file user_gemrc do
  content node['bootstrap']['gem_options']
end

