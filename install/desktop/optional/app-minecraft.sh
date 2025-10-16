#!/bin/bash

if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "Minecraft Launcher is officially packaged for amd64 only. Skipping install on $(dpkg --print-architecture)."
        return 0 2>/dev/null || exit 0
fi

sudo apt install -y openjdk-8-jdk

cd /tmp
wget https://launcher.mojang.com/download/Minecraft.deb
sudo apt install -y ./Minecraft.deb
rm Minecraft.deb
cd -
