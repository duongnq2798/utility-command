#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting the installation of Podman version > 3.4.0${NC}"

# Step 1: Update the system

echo -e "${GREEN}Updating the system...${NC}"
sudo apt-get update
sudo apt-get upgrade -y

# Step 2: Install Podman

echo -e "${GREEN}Installing Podman...${NC}"
. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$VERSION_ID/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
curl -L "http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$VERSION_ID/Release.key" | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install podman

# Step 3: Verify Podman version

echo -e "${GREEN}Verifying Podman version...${NC}"
podman --version

echo -e "${GREEN}Podman installation completed${NC}"
