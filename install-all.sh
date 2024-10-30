#!/bin/bash

# Array of installation scripts
scripts=(
    "install-awesome-wm.sh"
    "install-dev-tools.sh"
    "install-neovim.sh"
    "install-nerd-fonts.sh"
    "install-omzh"
    "install-tpm.sh"
    "node-scripts.sh"
)

# Make all scripts executable
chmod +x *.sh

# Run each script
for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        echo "Running $script..."
        ./"$script"
        echo "Completed $script"
        echo "-------------------"
    else
        echo "Warning: $script not found"
    fi
done

echo "All installations complete!"
