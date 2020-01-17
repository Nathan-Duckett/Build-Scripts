#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Script must be run as root"
    exit 1
fi

apt update -qq && apt upgrade -y -qq
apt install docker docker-compose -y -qq

# Jump back to root
cd ..

# Create config folder locations
mkdir -p ~/.media-config/jackett > /dev/null

# Add user permissions to user 'nathan' use docker
usermod -aG docker nathan

# Deploy all docker containers
cd docker-builds/jackett-only/
docker-compose up -d