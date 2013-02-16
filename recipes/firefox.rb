if node['bootstrap']['firefox']['mode'] == 'sources'
  node['bootstrap']['firefox']['packages'].each do |pkg|
    package pkg
  end

  ark "firefox" do
    url       node['bootstrap']['firefox']['url']
    checksum  node['bootstrap']['firefox']['md5sum']
    has_binaries [ "firefox", "firefox-bin" ]
  end

  # Add export LD_LIBRARY_PATH=/usr/local/firefox
  # to a profile script (/etc/profile.d/*.sh)
  file "/etc/profile.d/firefox.sh" do
    content  'export LD_LIBRARY_PATH=/usr/local/firefox'
  end
else
  firefox = value_for_platform(
    ["ubuntu"] => { "default" => "firefox" },
    ["debian"] => { "default" => "iceweasel" }
  )
  package firefox
end
