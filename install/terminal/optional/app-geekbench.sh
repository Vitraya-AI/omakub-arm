#!/bin/bash

GB_VERSION="6.4.0"
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64)
    GEEKBENCH_VARIANT="Linux"
    ;;
  arm64)
    GEEKBENCH_VARIANT="LinuxARM"
    ;;
  *)
    echo "Geekbench does not publish binaries for $ARCH; skipping install"
    exit 0
    ;;
esac

cd /tmp
gum spin --title "Downloading Geekbench $GB_VERSION..." -- \
  curl -sLo geekbench.tar.gz "https://cdn.geekbench.com/Geekbench-${GB_VERSION}-${GEEKBENCH_VARIANT}.tar.gz"
gum spin --title "Extracting Geekbench $GB_VERSION..." -- \
  tar -xzf geekbench.tar.gz
sudo mv "Geekbench-${GB_VERSION}-${GEEKBENCH_VARIANT}" /usr/local/geekbench6
sudo ln -sf /usr/local/geekbench6/geekbench6 /usr/local/bin/geekbench6
rm -rf Geekbench* geekbench.tar.gz
cd -
echo "Run as geekbench6 from the terminal"
