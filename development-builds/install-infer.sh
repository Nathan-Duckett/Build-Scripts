#!/bin/sh

# Based on latest release at https://github.com/facebook/infer/releases
VERSION=0.17.0;
sudo apt install curl -yqq
curl -sSL "https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz" \
| sudo tar -C /opt -xJ \
sudo ln -s "/opt/infer-linux64-v$VERSION/bin/infer" /usr/local/bin/infer