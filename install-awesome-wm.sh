#!/bin/bash

# Exit on any error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to display error messages
error() {
    echo "Error: $1" >&2
    exit 1
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    error "Please run as root (use sudo)"
fi

# Update package lists
echo "Updating package lists..."
apt-get update || error "Failed to update package lists"

# Install awesome WM and dependencies
echo "Installing Awesome WM and required packages..."
PACKAGES=(
    awesome
    awesome-extra
    nitrogen
    picom
    lxappearance
    xfce4-terminal
    rofi
    network-manager
    volumeicon-alsa
)

apt-get install -y "${PACKAGES[@]}" || error "Failed to install packages"

# Create default config directory if it doesn't exist
echo "Setting up configuration..."
mkdir -p /etc/xdg/awesome

# Copy default config if it doesn't exist
if [ ! -f /etc/xdg/awesome/rc.lua ]; then
    cp /usr/share/awesome/rc.lua /etc/xdg/awesome/rc.lua
fi

# Set up for current user
USER_HOME=$(eval echo ~${SUDO_USER})
mkdir -p "${USER_HOME}/.config/awesome"

# Copy config file if it doesn't exist
if [ ! -f "${USER_HOME}/.config/awesome/rc.lua" ]; then
    cp /etc/xdg/awesome/rc.lua "${USER_HOME}/.config/awesome/"
    chown -R ${SUDO_USER}:${SUDO_USER} "${USER_HOME}/.config/awesome"
fi

# Add Awesome to display manager sessions
if [ ! -f /usr/share/xsessions/awesome.desktop ]; then
    cat > /usr/share/xsessions/awesome.desktop << EOF
[Desktop Entry]
Name=Awesome
Comment=Highly configurable framework window manager
Exec=awesome
Type=Application
EOF
fi

echo "Installation complete! You can now select Awesome WM from your login screen."
echo "Remember to log out and choose Awesome as your window manager to start using it."
