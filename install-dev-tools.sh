#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update

# Add Docker's official GPG key
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add PHP repository
sudo add-apt-repository ppa:ondrej/php -y

# Add K8s repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists again after adding repositories
sudo apt update


# Install common developer tools
echo "Installing developer tools..."
PACKAGES=(
    alacritty
    ripgrep
    zoxide
    fzf
    tmux
    bat
    eza
    fd-find
    htop
    jq
    curl
    wget
    git
    zsh
    fish
    # C/C++ development tools
    build-essential
    gcc
    g++
    clang
    clangd
    lldb
    gdb
    make
    cmake
    ninja-build
    gettext
    unzip
    # Libraries and headers
    libc6-dev
    libstdc++-10-dev
    llvm
    # Python
    python3
    python3-pip
    python3-venv
    # PHP 8.3
    php8.3
    php8.3-cli
    php8.3-common
    php8.3-curl
    php8.3-mbstring
    php8.3-mysql
    php8.3-xml
    php8.3-zip
    # Docker
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
    # Kubernetes
    kubectl
    kubelet
    kubeadm
)

# Install all packages
sudo apt install -y "${PACKAGES[@]}"

# Install Zig using snap
echo "Installing Zig..."
sudo snap install zig --classic --beta

# Install Zellij using snap
echo "Installing Zellij..."
sudo snap install zellij --classic

# Install Node.js using nvm
echo "Installing NVM and Node.js..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load nvm and install latest Node.js
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node # Installs latest version
nvm use node

# Setup Docker group
sudo groupadd docker || true
sudo usermod -aG docker $USER

# Setup zoxide
if command -v zoxide >/dev/null; then
    echo "Setting up zoxide..."
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
fi

# Create bat -> batcat symlink (Ubuntu-specific)
if command -v batcat >/dev/null; then
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup shell configurations
echo "Setting up shell configurations..."

# Zsh configuration
if command -v zoxide >/dev/null; then
    echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
fi

# Fish configuration
mkdir -p ~/.config/fish
echo "if type -q zoxide" >> ~/.config/fish/config.fish
echo "    zoxide init fish | source" >> ~/.config/fish/config.fish
echo "end" >> ~/.config/fish/config.fish

# Add NVM to shell configs
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

# Change default shell to zsh
echo "Changing default shell to zsh..."
chsh -s $(which zsh)

# Create basic Zellij config directory
mkdir -p ~/.config/zellij

echo "Installation complete! Please log out and log back in for the changes to take effect."
echo "
Installed components:
- Shell tools: Zsh, Fish, Oh My Zsh
- Development tools: GCC, Clang, Make, CMake, Ninja
- Languages: Python 3, PHP 8.3, Node.js (via nvm), Zig
- Containers: Docker, Kubernetes (kubectl, kubelet, kubeadm)
- Terminal tools: Alacritty, Tmux, Zellij, etc.

Next steps:
1. Log out and log back in to:
   - Start using Zsh as your default shell
   - Apply Docker group changes
2. Verify installations:
   docker --version
   kubectl version
   php --version
   node --version
   python3 --version
"
