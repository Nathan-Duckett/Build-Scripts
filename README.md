# Build-Scripts
Basic Bash scripts to help with building up virtual machines or servers with the required software to run.

## Instructions to Use
Each section which follows outlines the instructions for each different section of code these scripts can run.

### Media Client
This installation will install all of the software natively on the system.
This will install all necessary software to create a media server. This includes:
- Plex
- Sonarr
- Radarr
- Jackett (To manage trackers for Sonarr and Radarr)

This can be run by performing:
```sh
sudo chmod +x media_build.sh
sudo ./media_build.sh
```
This script requires that you have sudo access to run. You must also fill in the required samba share password to connect the videos directory.

### Media Client (Docker)
This installation will install all of the software inside containers on the system.
This installs the same software as the normal media client but all within docker.

To install the client use:
```sh
sudo chmod +x media-docker.sh
sudo ./media-docker.sh
```

### Download Client
This will initialize and set up a torrent download system. All programs are within docker containers and will mount the corresponding directories required.

To install the client use:
```sh
sudo chmod +x download_build.sh
sudo ./download_build.sh
```