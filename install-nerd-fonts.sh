#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Nerd Fonts installation script...${NC}"

# Create fonts directory if it doesn't exist
echo "Creating fonts directory..."
mkdir -p ~/.local/share/fonts

# Array of popular Nerd Fonts
declare -a fonts=(
    "JetBrainsMono"
    "Hack"
    "FiraCode"
    "Meslo"
    "RobotoMono"
    "SourceCodePro"
    "UbuntuMono"
)

# Function to download and install font
install_font() {
    local font_name=$1
    echo -e "${BLUE}Installing ${font_name}...${NC}"
    
    # Create temporary directory
    temp_dir=$(mktemp -d)
    
    # Download font
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip" -P "$temp_dir"
    
    # Check if download was successful
    if [ $? -eq 0 ]; then
        # Unzip font
        unzip -q "$temp_dir/${font_name}.zip" -d "$temp_dir/${font_name}"
        
        # Copy only .ttf files
        find "$temp_dir/${font_name}" -name "*.ttf" -exec cp {} ~/.local/share/fonts/ \;
        
        echo -e "${GREEN}✓ ${font_name} installed successfully${NC}"
    else
        echo "Failed to download ${font_name}"
    fi
    
    # Clean up
    rm -rf "$temp_dir"
}

# Install required packages
echo "Installing required packages..."
sudo apt update
sudo apt install -y wget unzip

# Install each font
for font in "${fonts[@]}"; do
    install_font "$font"
done

# Refresh font cache
echo "Refreshing font cache..."
fc-cache -f

echo -e "${GREEN}Installation complete!${NC}"
echo "You may need to restart your terminal or applications to use the new fonts."

# List installed fonts
echo -e "${BLUE}Installed Nerd Fonts:${NC}"
fc-list | grep -i "nerd" | cut -d: -f2 | sort | uniq

exit 0
