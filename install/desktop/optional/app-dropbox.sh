#!/bin/bash

# Sync files across machines using https://dropbox.com
if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "Dropbox only distributes Linux binaries for amd64. Skipping install on $(dpkg --print-architecture)."
        return 0 2>/dev/null || exit 0
fi

sudo apt install -y nautilus-dropbox >/dev/null
