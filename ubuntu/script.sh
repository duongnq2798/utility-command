#!/bin/bash

# Script to upgrade Ubuntu to version 22.04 LTS

# Update package lists and upgrade installed packages
echo "Updating package lists and upgrading installed packages..."
apt update
apt upgrade -y

# Check for held packages and unhold them if necessary
echo "Checking for held packages..."
held_packages=$(apt-mark showhold)
if [ -n "$held_packages" ]; then
    echo "There are held packages. Unholding these packages..."
    for package in $held_packages; do
        apt-mark unhold "$package"
    done
else
    echo "There are no held packages."
fi

# Perform a system upgrade
echo "Performing system upgrade..."
apt full-upgrade -y

# Remove old kernels and unneeded dependencies
echo "Removing old kernels and unneeded dependencies..."
apt --purge autoremove -y

# Install update-manager-core if not already installed
if ! dpkg -l | grep -q update-manager-core; then
    echo "Installing update-manager-core..."
    apt install update-manager-core -y
fi

# Ensure the upgrade policy in /etc/update-manager/release-upgrades is set correctly
echo "Ensuring the upgrade policy in /etc/update-manager/release-upgrades is set to 'Prompt=lts'..."
sed -i 's/^Prompt=.*$/Prompt=lts/' /etc/update-manager/release-upgrades

# Open port 1022 if upgrading via SSH
echo "Opening port 1022 if needed..."
iptables -I INPUT -p tcp --dport 1022 -j ACCEPT

# Start the upgrade to Ubuntu 22.04 LTS
echo "Starting the upgrade to Ubuntu 22.04 LTS..."
do-release-upgrade -f DistUpgradeViewNonInteractive

# Prompt to reboot after the upgrade
echo "Upgrade complete. You need to reboot the server to apply changes."
echo "Press Enter to reboot immediately..."
read
reboot
