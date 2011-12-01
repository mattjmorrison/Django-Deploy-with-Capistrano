#!/bin/bash
host="${1}"
json="${2}"

if [ -z "$host" ] || [ -z "$json" ]; then
    echo "Usage: ./deploy.sh [user@host] [json]"
    exit
fi

tar cz . | ssh -o 'StrictHostKeyChecking no' "$host" "
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xz &&
sudo bash install.sh $json"
