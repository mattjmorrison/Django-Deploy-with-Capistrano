#!/bin/bash

# root@50.57.191.25
# xxxxxx5NjQe17gR

host="${1}"

if [ -z "$host" ]; then
    echo "Usage: ./deploy.sh [user@host]"
    exit
fi

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
#echo 'keygen'
#ssh-keygen -R "${host#*@}" 2> /dev/null

echo 'copy chef dir & run install.sh'
tar cz . | ssh -o 'StrictHostKeyChecking no' "$host" "
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xz &&
sudo bash install.sh"