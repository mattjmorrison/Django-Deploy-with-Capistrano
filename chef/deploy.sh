#!/bin/bash

host="${1}"
json="${2}"

if [ -z "$host" ]; then
    echo "Usage: ./deploy.sh [user@host] [json]"
    echo "If no json is given it will default to solo.json"
    exit
fi

if [ -z "$json" ]; then
	json="solo.json"
fi

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
echo 'keygen'
ssh-keygen -R "${host#*@}" 2> /dev/null

echo 'copy chef dir & run install.sh'
tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" "
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh $json"