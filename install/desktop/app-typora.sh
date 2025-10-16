#!/bin/bash

# Temporarily switch away from using Typora repo which is broken.
#
# wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc >/dev/null || true
#
# sudo add-apt-repository -y 'deb https://typora.io/linux ./'
# sudo add-apt-repository -y 'deb https://typora.io/linux ./'
# sudo apt update -y
# sudo apt install -y typora

# Install with db
cd /tmp
ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
  amd64|arm64)
    TYPO_ARCH="$ARCH"
    ;;
  *)
    echo "Typora does not provide installers for $ARCH; skipping install"
    exit 0
    ;;
esac

wget -O typora.deb "https://downloads.typora.io/linux/typora_1.10.8_${TYPO_ARCH}.deb"
sudo apt install -y /tmp/typora.deb
rm typora.deb
cd -

# Add iA Typora theme
mkdir -p ~/.config/Typora/themes
cp ~/.local/share/omakub/configs/typora/ia_typora.css ~/.config/Typora/themes/
cp ~/.local/share/omakub/configs/typora/ia_typora_night.css ~/.config/Typora/themes/
