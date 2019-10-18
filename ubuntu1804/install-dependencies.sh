#!/bin/bash

# Update and install dependencies
apt update && apt upgrade -y
apt install -y git docker docker-compose cifs-utils
apt install -y libcurl4-openssl-dev mono-devel