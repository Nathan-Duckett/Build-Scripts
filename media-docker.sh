#!/bin/bash

if [ $EUID != 0 ]; then
    echo "You must run this as root"
    exit
fi

echo "Getting pre-requiste information"
read -p 'Network Share IP: ' NETWORK_SHARE_IP
read -p 'Network Share Username: ' SMB_SHARE_USERNAME
read -sp 'Network Share Password: ' SMB_SHARE_PASSWORD

echo "Installing software"
apt update > /dev/null
apt upgrade -y > /dev/null
apt install cifs-utils docker docker-compose -y > /dev/null

# Mount SMB Network Shares
echo "Mounting network shares"

cat > ~/.smbcredentials << EOF
username=$SMB_SHARE_USERNAME
passsword=$SMB_SHARE_PASSWORD
EOF
chmod 600 ~/.smbcredentials

mkdir /mnt/download > /dev/null
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/Download /mnt/download > /dev/null

mkdir /mnt/videos > /dev/null
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/Videos /mnt/videos > /dev/null

echo "//$NETWORK_SHARE_IP/Download /mnt/download cifs credentials=/home/$USER/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab
echo "//$NETWORK_SHARE_IP/Videos /mnt/videos cifs credentials=/home/$USER/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab


# Create config folder locations
mkdir ~/.media-config/ > /dev/null
mkdir ~/.media-config/plex/ > /dev/null
mkdir ~/.media-config/sonarr/ > /dev/null
mkdir ~/.media-config/radarr/ > /dev/null
mkdir ~/.media-config/jackett/ > /dev/null

mkdir -p ~/.transcode/temp > /dev/null

echo "Building Docker Containers"
cd docker-builds/media/
docker-compose up -d > /dev/null

echo "Installation Complete. Enjoy the server"