# A Communication platform for voice, video, and text messaging https://discord.com/
if [ "$(dpkg --print-architecture)" != "amd64" ]; then
        echo "Discord does not publish native Linux installers for $(dpkg --print-architecture). Skipping install."
        return 0 2>/dev/null || exit 0
fi

cd /tmp
wget https://discord.com/api/download?platform=linux -O discord.deb
sudo apt install ./discord.deb -y
rm discord.deb
cd -