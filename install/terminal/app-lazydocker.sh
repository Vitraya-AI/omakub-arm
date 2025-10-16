#!/bin/bash

cd /tmp
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64)
    LAZYDOCKER_ASSET_ARCH="Linux_x86_64"
    ;;
  arm64)
    LAZYDOCKER_ASSET_ARCH="Linux_arm64"
    ;;
  *)
    echo "lazydocker does not publish binaries for $ARCH; skipping install"
    exit 0
    ;;
esac

curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_${LAZYDOCKER_ASSET_ARCH}.tar.gz"
tar -xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm lazydocker.tar.gz lazydocker
cd -
