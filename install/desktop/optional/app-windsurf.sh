#!/bin/bash

if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "Windsurf packages are published for amd64 only. Skipping install on $(dpkg --print-architecture)."
        return 0 2>/dev/null || exit 0
fi

curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/windsurf-stable-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list >/dev/null

sudo apt update -y
sudo apt install -y windsurf
