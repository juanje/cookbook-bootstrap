# User info
if node.has_key? 'instance_role' and node['instance_role'] == 'vagrant'
  default['bootstrap']['user'] = 'vagrant'
else
  default['bootstrap']['user'] = 'aentos'
  # NOTE: The password hash was created with:
  # openssl passwd -1 "aentos"
  default['bootstrap']['password'] = '$1$q0ic4MNE$T55nMWfHyZfPeuz2dMoKY1'
  default['bootstrap']['shell'] = '/bin/bash'
end

# Set some handy vars
default['user_name'] = node['bootstrap']['user']
default['user_home'] = "/home/#{node['user_name']}"
default['user_env'] = {
  'USER' => node['user_name'],
  'HOME' => node['user_home']
}

# include these recipes?
default['bootstrap']['postgresql'] = true
default['bootstrap']['mongodb'] = true
default['bootstrap']['testing'] = true
default['bootstrap']['java'] = true

# Postgresql
default['bootstrap']['postgresql_password'] = 'aentos'
include_attribute 'postgresql'
node.set['postgresql']['password']['postgres'] = node['bootstrap']['postgresql_password']

# Dependencies
default['bootstrap']['packages']['base'] = %w{
  vim screen tmux git bash-completion
}
default['bootstrap']['packages']['testing'] = %w{
  icewm vnc4server
}
default['bootstrap']['packages']['java'] = %w{
  openjdk-7-jre-headless
}
default['bootstrap']['packages']['extra'] = []

# Firefox
default['bootstrap']['firefox']['mode'] = 'packages'
default['bootstrap']['firefox']['packages'] = %w{ libgtk2.0-0 libpango1.0-0 }
default['bootstrap']['firefox']['url'] = "http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/18.0.2/linux-#{node['kernel']['machine']}/en-US/firefox-18.0.2.tar.bz2"
if node['kernel']['machine'] == 'x86_64'
  default['bootstrap']['firefox']['md5sum'] = '685c7337c97b56b02ca1c589588309328b5b7db834f3c5978eecdb0f359c3d95'
else
  default['bootstrap']['firefox']['md5sum'] = 'd2cd02bf406a94acc1b18e555b5ae45d809893e21495ca5a9ecd8cce94af4d6f'
end

# System scripts and settings
default['bootstrap']['init_scripts'] = %w{
  icewm xvnc
}

# RVM and gem settings
default['bootstrap']['rvm']['installer_url'] = "https://get.rvm.io"
default['bootstrap']['rvm']['branch']  = "stable"
default['bootstrap']['rvm']['ruby'] = '1.9.3'
default['bootstrap']['rvm']['packages'] = %w{
  build-essential openssl libreadline6 libreadline6-dev curl git-core
  zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3
  libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool
  bison ssl-cert subversion pkg-config
}
default['bootstrap']['rvm']['clean_sources'] = true
default['bootstrap']['gem_options'] = 'gem: --no-rdoc --no-ri -V'

# Shell stuff
default['bootstrap']['ps1'] = %q{PS1='\[\e[36m\]\u@\h \[\e[32m\][$rvm_env_string] \[\e[35m\]($(git symbolic-ref HEAD 2> /dev/null | xargs -r basename))\[\e[36m\] \w\$\[\e[m\] '}
