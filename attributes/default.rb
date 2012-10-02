# User info
default['bootstrap']['user'] = 'aentos'
default['bootstrap']['uid'] = 1000
default['bootstrap']['gid'] = 1000
# NOTE: The password hash was created with:
# openssl passwd -1 "aentos"
default['bootstrap']['password'] = '$1$q0ic4MNE$T55nMWfHyZfPeuz2dMoKY1'
default['bootstrap']['shell'] = '/bin/bash'

# Dependencies
default['bootstrap']['packages'] = %w{icewm vnc4server firefox vim screen tmux git}

# System scripts and settings
default['bootstrap']['init_scripts'] = %w{icewm xvnc}

# RVM and gem settings
default['bootstrap']['default_ruby'] = '1.9.3-p194-perf'
default['bootstrap']['rubies'] = [
  {
    'version' => '1.9.3-p194-perf',
    'patch'   => 'falcon'
  }
]
default['bootstrap']['gem_options'] = 'gem: --no-rdoc --no-ri -V'
default['bootstrap']['ps1'] = "PS1='\[\e[36m\]\u@\h \[\e[32m\][$rvm_env_string] \[\e[35m\]($(git symbolic-ref HEAD 2> /dev/null | xargs -r basename))\[\e[36m\] \w\$\[\e[m\] '"
