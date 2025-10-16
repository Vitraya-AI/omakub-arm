#!/bin/bash

# Gum is used for the Omakub commands for tailoring Omakub after the initial install
cd /tmp
GUM_VERSION="0.14.3" # Use known good version
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64|arm64)
    GUM_PACKAGE_ARCH="$ARCH"
    ;;
  *)
    echo "gum is not published for $ARCH; skipping install"
    exit 0
    ;;
esac

wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_${GUM_PACKAGE_ARCH}.deb"
sudo apt-get install -y --allow-downgrades ./gum.deb
rm gum.deb
cd -
