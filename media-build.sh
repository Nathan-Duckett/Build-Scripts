#!/bin/sh

# Enable execution on all scripts required
chmod +x ./ubuntu1804/install-dependencies.sh
chmod +x ./mount-shares.sh
chmod +x ./ubuntu1804/media/install-plex.sh
chmod +x ./ubuntu1804/media/install-jackett.sh
chmod +x ./ubuntu1804/media/install-radarr.sh
chmod +x ./ubuntu1804/media/install-sonarr.sh

# Setup dependencies and drives
./ubuntu1804/install-dependencies.sh
./mount-shares.sh

# Install all media services
./ubuntu1804/media/install-plex.sh
./ubuntu1804/media/install-jackett.sh
./ubuntu1804/media/install-radarr.sh
./ubuntu1804/media/install-sonarr.sh