# Build-Scripts
This is a collection of scripts to help with building and configuring systems and services on certain systems. The main goal is to have automated scripts for each piece of software used within my setup so systems can be quickly replicated including choice of what software is installed on that system.

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
This installation will install all of the software inside containers on the system. This system is designed to handle managing tv shows and movies on the system with automated downloading. (Requires external download client and media server)
This installs the same software (excluding plex) as the normal media client but all within docker.

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

### Full Server
This will install all services required on the server. This includes plex, sonarr, radarr, jackett, and qBittorrent. These are all hosted within docker containers.

To install this client use:
```sh
sudo chmod +x full_server.sh
sudo ./full_server.sh
```

### Developer Build

Run this command:
```sh
wget -O - "https://raw.githubusercontent.com/Nathan-Duckett/Build-Scripts/master/development-builds/build-dev.sh" | bash
```
This will automatically install and configure all of the required software for a developer build.
