#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

json="${1}"

if [ -z "$json" ]; then
    echo "Usage: ./install.sh [json]"
    exit
fi

# if we're on a vanilla system, install everything
if ! test -f "`which chef-solo`" && ! test -f "`which rvm`"; then
	# Upgrade headlessly (this is only safe-ish on vanilla systems)
	apt-get update -o Acquire::http::No-Cache=True
	apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade
	apt-get install -y curl git-core build-essential zlib1g-dev libssl-dev openssl #bzip2

	if ! test -f "`which rvm`"; then
		bash <( curl -L https://github.com/wayneeseguin/rvm/raw/1.3.0/contrib/install-system-wide ) --version '1.3.0'
		(cat <<'EOP'
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm" # This loads RVM into a shell session.
EOP
		) > /etc/profile.d/rvm.sh
		[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
		rvm install 1.9.2-p290
	fi
	rvm use 1.9.2-p290 --default
	gem install --no-rdoc --no-ri chef --version 0.10.0
fi

[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"
`which chef-solo` --config solo.rb --json-attributes $json