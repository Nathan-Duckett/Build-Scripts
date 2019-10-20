#!/bin/bash

# Update the system
apt update && apt upgrade -y

# Getting mono dependencies
apt install gnupg ca-certificates
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" > /etc/apt/sources.list.d/mono-official-stable.list
apt update

# Install Mono
apt install -y libcurl4-openssl-dev mono-devel

# Install git, docker and network drive
apt install -y git docker docker-compose cifs-utils