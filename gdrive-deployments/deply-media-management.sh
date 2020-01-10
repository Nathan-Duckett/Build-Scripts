#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Script must be run as root"
    exit 1
fi

apt update -qq && apt upgrade -y -qq
apt install docker docker-compose -y -qq

# Jump back to root
cd ..

# Add Gdrive mount
bash mount-gdrive-plex.sh

# Create config folder locations
mkdir -p ~/.media-config/sonarr/
mkdir ~/.media-config/radarr/
mkdir ~/.media-config/ombi/

# Deploy all docker containers
cd docker-builds/media-management/
docker-compose up -d