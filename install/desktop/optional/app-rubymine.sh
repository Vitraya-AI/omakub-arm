#!/bin/bash

if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "RubyMine snap is only available for amd64. Skipping install on $(dpkg --print-architecture)."
        return 0 2>/dev/null || exit 0
fi

sudo snap install rubymine --classic
