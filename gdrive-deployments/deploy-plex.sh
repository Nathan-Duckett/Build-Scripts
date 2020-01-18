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

# Install plex natively
bash ubuntu1804/media/install-plex.sh

# Create config folder locations
mkdir -p ~/.media-config/tautulli/

# Add user permissions to user 'nathan' use docker
usermod -aG docker nathan

# Create and launch Tautulli
cd docker-builds/tautulli-only/
docker-compose up -d