name             "bootstrap"
maintainer       "Juanje Ojeda"
maintainer_email "juanje.ojeda@gmail.com"
license          "Apache 2.0"
description      "Bootstrap a Aentos Rails project"
version          "0.1.2"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ mongodb postgresql apt sudo conf ark }.each do |os|
  depends os
end

