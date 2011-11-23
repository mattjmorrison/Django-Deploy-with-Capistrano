#!/bin/bash

logfile="/root/chef-solo.log"

# This runs as root on the server
chef_binary="/usr/local/rvm/gems/ruby-1.9.2-p290/bin/chef-solo"

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then

     export DEBIAN_FRONTEND=noninteractive

     # Upgrade headlessly (this is only safe-ish on vanilla systems)
     apt-get update -o Acquire::http::No-Cache=True
     apt-get -o Dpkg::Options::="--force-confnew" \
         --force-yes -fuy dist-upgrade

     # Install RVM as root (System-wide install)
     apt-get install -y curl git-core bzip2 build-essential zlib1g-dev libssl-dev

     # Note system-wide installs are not in the RVM main version
     # bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
     bash <( curl -L https://github.com/wayneeseguin/rvm/raw/1.3.0/contrib/install-system-wide ) --version '1.3.0'
     (cat <<'EOP'
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session.
EOP
     ) > /etc/profile.d/rvm.sh

     # Install Ruby using RVM
     [[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
     rvm install 1.9.2-p290
     rvm use 1.9.2-p290 --default

     # Upgrade rubygems (Latest version 1.8.10 has a lot of problems)
     # Use 'bundle exec' in front of everything
     # 1.7.2 - is suggested but I've found issues with this as well.
     # 1.6.2 - is what I use on my dev box and comes with rvm install
     # gem update --system
     
     # Install chef
     gem install --no-rdoc --no-ri chef --version 0.10.0
fi

# Run chef-solo on server
echo "Run $chef_binary"
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
"$chef_binary" --config solo.rb