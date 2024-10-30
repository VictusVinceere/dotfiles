#!/bin/bash

echo "Starting Neovim build script..."

# Function to check if command succeeded
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Update system
echo "Updating system..."
sudo apt-get update
check_error "Failed to update system"

# Install dependencies
echo "Installing dependencies..."
sudo apt-get install -y ninja-build gettext cmake unzip curl git python3-pip
check_error "Failed to install dependencies"

# Remove old neovim if exists
echo "Removing old Neovim installation if it exists..."
sudo apt remove -y neovim
sudo apt purge -y neovim

# Clone Neovim
echo "Cloning Neovim repository..."
if [ -d "neovim" ]; then
    echo "Removing existing neovim directory..."
    rm -rf neovim
fi
git clone https://github.com/neovim/neovim
check_error "Failed to clone repository"

# Build Neovim
echo "Building Neovim..."
cd neovim
make CMAKE_BUILD_TYPE=Release
check_error "Failed to build Neovim"

# Install Neovim
echo "Installing Neovim..."
sudo make install
check_error "Failed to install Neovim"

# Install Python support
echo "Installing Python support..."
pip3 install pynvim
check_error "Failed to install Python support"

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
check_error "Failed to install Node.js"

# Install Node provider
echo "Installing Node provider..."
sudo npm install -g neovim
check_error "Failed to install Node provider"

# Verify installation
echo "Verifying installation..."
nvim --version
check_error "Failed to verify installation"

echo "Neovim installation completed successfully!"
