#!/bin/bash

# Make video calls using https://zoom.us/
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64)
    ZOOM_DEB="zoom_amd64.deb"
    ;;
  arm64)
    ZOOM_DEB="zoom_arm64.deb"
    ;;
  *)
    echo "Zoom does not publish Debian packages for $ARCH. Skipping install."
    return 0 2>/dev/null || exit 0
    ;;
esac

cd /tmp
wget "https://zoom.us/client/latest/${ZOOM_DEB}"
sudo apt install -y "./${ZOOM_DEB}"
rm "${ZOOM_DEB}"
cd -
