#!/bin/bash

# Define colors for formatting
BOLD="\033[1m"
DARK_YELLOW="\033[33m"
RESET="\033[0m"

execute_with_prompt() {
    echo -e "${BOLD}${DARK_YELLOW}\$ $1${RESET}"
    eval $1
}

echo -e "${BOLD}${DARK_YELLOW}Updating system dependencies...${RESET}"
execute_with_prompt "sudo apt update -y && sudo apt upgrade -y"
echo

echo -e "${BOLD}${DARK_YELLOW}Installing packages...${RESET}"
execute_with_prompt "sudo apt install ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make jq build-essential pkg-config lsb-release libssl-dev libreadline-dev libffi-dev gcc screen unzip lz4 -y"
echo

echo -e "${BOLD}${DARK_YELLOW}Installing python3...${RESET}"
execute_with_prompt "sudo apt install python3 python3-pip -y"
echo

echo -e "${BOLD}${DARK_YELLOW}Installing Docker...${RESET}"
execute_with_prompt "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg"
echo
execute_with_prompt "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null"
echo
execute_with_prompt "sudo apt-get update"
echo
execute_with_prompt "sudo apt-get install docker-ce docker-ce-cli containerd.io -y"
echo

echo -e "${BOLD}${DARK_YELLOW}Checking docker version...${RESET}"
execute_with_prompt "docker version"
echo

echo -e "${BOLD}${DARK_YELLOW}Installing Docker Compose...${RESET}"
VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
echo
execute_with_prompt "sudo curl -L https://github.com/docker/compose/releases/download/${VER}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose"
echo
execute_with_prompt "sudo chmod +x /usr/local/bin/docker-compose"
echo

echo -e "${BOLD}${DARK_YELLOW}Checking docker-compose version...${RESET}"
execute_with_prompt "docker-compose --version"
echo

if ! grep -q "^docker:" /etc/group; then
    execute_with_prompt "sudo groupadd docker"
    echo
fi

execute_with_prompt "sudo usermod -aG docker \$USER"
echo

echo -e "${BOLD}${DARK_YELLOW}Docker installation completed. Please log out and log back in for the changes to take effect.${RESET}"
