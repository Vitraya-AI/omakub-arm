#!/bin/bash

# Browse the web with the most popular browser. See https://www.google.com/chrome/
if [ "$(dpkg --print-architecture)" != "amd64" ]; then
  echo "Google Chrome for Linux is only published for amd64. Skipping install on $(dpkg --print-architecture)."
  return 0 2>/dev/null || exit 0
fi

cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
xdg-settings set default-web-browser google-chrome.desktop
cd -
