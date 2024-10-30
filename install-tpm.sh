#!/bin/bash

echo "Starting TPM installation..."

# Install tmux if not present
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    sudo apt update
    sudo apt install -y tmux
fi

# Install git if not present
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo apt install -y git
fi

# Install TPM
echo "Installing TPM..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "TPM installation complete!"
echo ""
echo "To use TPM:"
echo "1. Add plugins to ~/.tmux.conf"
echo "2. Press prefix + I to install plugins"
echo "3. Press prefix + U to update plugins"

exit 0
