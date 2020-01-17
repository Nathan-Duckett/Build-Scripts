#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Script must be run as root"
    exit 1
fi

read -p 'Network Share IP: ' NETWORK_SHARE_IP
read -p 'Network Share Username: ' SMB_SHARE_USERNAME

apt update -qq && apt upgrade -y -qq
apt install arch-install-scripts cifs-utils docker docker-compose -y -qq

mkdir /mnt/download > /dev/null
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Download /mnt/download

genfstab -U /mnt/download >> /etc/fstab

# Jump back to root
cd ..

# Add Gdrive mount
bash mount-gdrive-plex.sh

# Create config folder locations
mkdir -p ~/.media-config/sonarr/
mkdir ~/.media-config/radarr/
mkdir ~/.media-config/ombi/

# Add user permissions to user 'nathan' use docker
usermod -aG docker nathan

# Deploy all docker containers
cd docker-builds/media-management/
docker-compose up -d