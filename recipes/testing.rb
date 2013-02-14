node['bootstrap']['packages']['testing'].each do |pkg|
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

# Add export DISPLAY=:0 to a profile script (/etc/profile.d/*.sh)
file "/etc/profile.d/display.sh" do
  content  'export DISPLAY=:0'
end

