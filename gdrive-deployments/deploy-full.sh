#/bin/bash

# Update and get dependencies
sudo apt update -qq
sudo apt upgrade -yqq
sudo apt install docker docker-compose -yqq

# Add user permissions to user 'nathan' use docker
sudo usermod -aG docker nathan

# Jump back to root
cd ..

bash mount-gdrive-plex.sh

# Install plex natively
sudo bash ubuntu1804/media/install-plex.sh

# Install nicer shell
bash ubuntu1804/install-shell.sh

# Create config folder locations
mkdir -p ~/.media-config/tautulli/


# Create and launch media-management software
cd docker-builds/media-management/
docker-compose up -d

# Create and launch Tautulli
cd ../tautulli-only/
docker-compose up -d

# Create and launch Jackett indexer
cd ../jackett-only/
docker-compose up -d

# Create and launch torrent downloader
cd ../qbittorrent-only/
docker-compose up -d