#!/bin/bash
# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb
apt install google-chrome-stable

# System Update and Upgrade
apt update
apt upgrade
apt dist-upgrade

# Install TLP
apt install tlp tlp-rdw
tlp start

# Install Preload
apt install preload

# Install Drivers
ubuntu-drivers autoinstall

# Install git
apt install git

# Install snap
apt install snapd

# Install VS Code
snap install code --classic

# Install Slack
snap install slack --classic

# Install Gimp:
snap install gimp

# Install Spotify
snap install spotify

# Remove wifi card power management
sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

#Wifi speed (turning on Tx AMPDU for intel wifi card)
echo "options iwlwifi 11n_disable=8" | sudo tee /etc/modprobe.d/iwlwifi-speed.conf
#if problem:
#rm -v /etc/modprobe.d/iwlwifi-speed.conf

#Disable bluetooth for battery life
echo "blacklist btusb" | sudo tee /etc/modprobe.d/blacklist-bluetooth.conf
# Temporary bluetooth activation
#modprobe -v btusb
# Permenant bluetooth reactivation
#rm -v /etc/modprobe.d/blacklist-bluetooth.conf

# Fix gyro problems
apt-get remove iio-sensor-proxy

# Remove search database
apt purge mlocate locate
# To reinstall the search database
apt install mlocate

# Hardening!!
# Install netstat
apt install net-tools

# Remove CUPS
apt autoremove cups-daemon

# Remove Avahi (fuck Apple!!)
apt purge avahi-daemon

# Block everything with a Firewall
ufw enable
ufw default deny incoming
ufw default deny forward
ufw default deny outgoing

# Setup exception with Firewall
ufw allow out on <interface> to 1.1.1.1 proto udp port 53 comment 'allow DNS on <interface>'
ufw allow out on <interface> to any proto tcp port 80 comment 'allow HTTP on <interface>'
ufw allow out on <interface> to any proto tcp port 443 comment 'allow HTTPS on <interface>'

# Github SSH over HTTPS port 443
cat <<EOT >> ~/.ssh/config
Host github.com
  Hostname ssh.github.com
  Port 443
EOT

# Turn firewall logging off
ufw logging off

# Harden /etc/sysctl.conf
sysctl kernel.modules_disabled=1
sysctl -a
sysctl -A
sysctl net.ipv4.conf.all.rp_filter

# Enable fail2ban
apt install fail2ban
cp fail2ban.local /etc/fail2ban/
systemctl enable fail2ban
systemctl start fail2ban

#System Cleanup
apt autoclean
apt clean
apt autoremove
