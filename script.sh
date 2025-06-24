#!/bin/bash 

set -e # Exit immediately if a command exits with a non-zero status

# Install Terraform 
    install_terraform() {
    echo "Installing Terraform..."

# Update and install required packages
    sudo apt-get update -y
    sudo apt-get install -y gnupg software-properties-common curl wget

# Add HashiCorp GPG key and repository
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
    echo "HashiCorp GPG key added successfully."

# Add the HashiCorp repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform
    sudo apt update -y
    sudo apt-get install -y terraform

# Confirm installation
    terraform -version
    echo "Terraform installed successfully."
}

# Main function to execute the script
main () {
    install_terraform
}

main