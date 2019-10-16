#!/bin/sh

# Setup dependencies and drives
./ubuntu1804/install-dependencies.sh
./mount-shares.sh

# Install all media services
./ubuntu1804/media/install-plex.sh
./ubuntu1804/media/install-jackett.sh
./ubuntu1804/media/install-radarr.sh
./ubuntu1804/media/install-sonarr.sh