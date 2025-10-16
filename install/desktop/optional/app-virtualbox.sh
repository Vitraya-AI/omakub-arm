#!/bin/bash

# Virtualbox allows you to run VMs for other flavors of Linux or even Windows
# See https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview
# for a guide on how to run Ubuntu inside it.

if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "VirtualBox is only packaged for x86 hosts. Skipping install on $(dpkg --print-architecture)."
        return 0 2>/dev/null || exit 0
fi

sudo apt install -y virtualbox virtualbox-ext-pack
sudo usermod -aG vboxusers ${USER}
