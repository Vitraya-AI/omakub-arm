#!/bin/bash

cd /tmp
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64)
    LAZYGIT_ASSET_ARCH="linux_x86_64"
    ;;
  arm64)
    LAZYGIT_ASSET_ARCH="linux_arm64"
    ;;
  *)
    echo "lazygit does not publish binaries for $ARCH; skipping install"
    exit 0
    ;;
esac

curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ASSET_ARCH}.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
mkdir -p ~/.config/lazygit/
touch ~/.config/lazygit/config.yml
cd -
