#!/bin/sh
NETWORK_SHARE_IP = 192.168.1.39
SMB_SHARE_USERNAME = natha
user = nathan

# Mount SMB Network Shares
mkdir /mnt/download
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Download /mnt/download
mkdir ~/vpnconfig
cp /mnt/download/nl-aes-128-cbc-udp-dns.ovpn ~/vpnconfig/

apt install docker
usermod -aG docker $user

cd docker-builds/download-only/
docker-compose up