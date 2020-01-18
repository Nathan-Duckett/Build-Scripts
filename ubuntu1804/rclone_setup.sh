#!/bin/bash

# Download latest copy of rclone
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64

# Move to installation location
cp rclone /usr/bin/
chown root:root /usr/bin/rclone
chmod 755 /usr/bin/rclone

# Install rclone manpages
mkdir -p /usr/local/share/man/man1
cp rclone.1 /usr/local/share/man/man1/
mandb

mkdir /mnt/tv-gd
mkdir /mnt/m-gd

# Plexdrive
wget https://github.com/dweidenfeld/plexdrive/releases/download/5.0.0/plexdrive-linux-amd64
mv plexdrive-linux-amd64 /usr/local/bin/plexdrive
chown root:root /usr/local/bin/plexdrive
chmod 755 /usr/local/bin/plexdrive

/usr/local/bin/plexdrive mount /mnt/plexdrive/