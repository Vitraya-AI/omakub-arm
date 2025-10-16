#!/bin/bash

cd /tmp
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64)
    ZELLIJ_ARCH="x86_64-unknown-linux-musl"
    ;;
  arm64)
    ZELLIJ_ARCH="aarch64-unknown-linux-musl"
    ;;
  *)
    echo "zellij does not publish binaries for $ARCH; skipping install"
    exit 0
    ;;
esac

wget -O zellij.tar.gz "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${ZELLIJ_ARCH}.tar.gz"
tar -xf zellij.tar.gz zellij
sudo install zellij /usr/local/bin
rm zellij.tar.gz zellij
cd -

mkdir -p ~/.config/zellij/themes
[ ! -f "$HOME/.config/zellij/config.kdl" ] && cp ~/.local/share/omakub/configs/zellij.kdl ~/.config/zellij/config.kdl
cp ~/.local/share/omakub/themes/tokyo-night/zellij.kdl ~/.config/zellij/themes/tokyo-night.kdl
