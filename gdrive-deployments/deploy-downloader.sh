#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Script must be run as root"
    exit 1
fi

apt update -qq && apt upgrade -y -qq
apt install samba
apt install docker docker-compose -y -qq

# Jump back to root
cd ..

mkdir -p /mnt/downloads

cat >> /etc/samba/smb.conf << EOF
[downloads]
    path = /mnt/downloads
    read only = no
    browsable = yes
    guest ok = no
EOF

service smbd restart
smbpasswd -a $USER

# Create config folder locations
mkdir -p ~/.media-config/qbittorrent > /dev/null

# Deploy all docker containers
cd docker-builds/qbittorrent-only/
docker-compose up -d