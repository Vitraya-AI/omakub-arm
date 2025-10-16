#!/bin/bash

# Play games from https://store.steampowered.com/
if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "Steam for Linux targets amd64 with 32-bit compatibility libraries. Skipping install on $(dpkg --print-architecture)."
        return 0 2>/dev/null || exit 0
fi

cd /tmp
wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo apt install -y ./steam.deb
rm steam.deb
cd -
