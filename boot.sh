#!/bin/bash

set -e

ascii_art='________                  __        ___.
\_____  \   _____ _____  |  | ____ _\_ |__
 /   |   \ /     \\__   \ |  |/ /  |  \ __ \
/    |    \  Y Y  \/ __ \|    <|  |  / \_\ \
\_______  /__|_|  (____  /__|_ \____/|___  /
        \/      \/     \/     \/         \/
'

echo -e "$ascii_art"
echo "=> Omakub is for fresh Ubuntu 24.04+ installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

echo "Cloning Omakub..."
rm -rf ~/.local/share/omakub
git clone https://github.com/basecamp/omakub.git ~/.local/share/omakub >/dev/null
if [[ $OMAKUB_REF != "master" ]]; then
	cd ~/.local/share/omakub
	git fetch origin "${OMAKUB_REF:-stable}" && git checkout "${OMAKUB_REF:-stable}"
	cd -
fi

echo "Installation starting..."

# Detect the system architecture and run the matching installer. Default to the
# original installer if the ARM64 script is not available so this boot script
# still works for upstream clones.
architecture="$(dpkg --print-architecture 2>/dev/null || uname -m)"

if [[ "$architecture" =~ ^(arm64|aarch64)$ ]] && [[ -f ~/.local/share/omakub/install-arm64.sh ]]; then
  source ~/.local/share/omakub/install-arm64.sh
else
  source ~/.local/share/omakub/install.sh
fi
