#!/bin/sh

if [ "$EUID" != "0" ]; then
    echo "Must run as root"
    exit 1
fi

apt update && apt upgrade -y

# Installing Secrethub
echo "deb [trusted=yes] https://apt.secrethub.io stable main" > /etc/apt/sources.list.d/secrethub.sources.list && apt-get update
apt-get install -y secrethub-cli