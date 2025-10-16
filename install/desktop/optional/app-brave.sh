#!/bin/bash

ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64|arm64)
    ;;
  *)
    echo "Brave only provides deb packages for amd64 and arm64. Skipping install on $ARCH."
    return 0 2>/dev/null || exit 0
    ;;
esac

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=$ARCH] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install -y brave-browser
