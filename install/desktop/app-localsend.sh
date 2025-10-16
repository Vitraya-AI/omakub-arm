#!/bin/bash

cd /tmp
LOCALSEND_VERSION=$(curl -s "https://api.github.com/repos/localsend/localsend/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64)
    LOCALSEND_DEB_SUFFIX="linux-x86-64"
    ;;
  arm64)
    LOCALSEND_DEB_SUFFIX="linux-arm-64"
    ;;
  *)
    echo "LocalSend does not publish binaries for $ARCH; skipping install"
    exit 0
    ;;
esac

wget -O localsend.deb "https://github.com/localsend/localsend/releases/latest/download/LocalSend-${LOCALSEND_VERSION}-${LOCALSEND_DEB_SUFFIX}.deb"
sudo apt install -y ./localsend.deb
rm localsend.deb
cd -
