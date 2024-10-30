# Add NodeSource repository for Node.js LTS
echo "Adding NodeSource repository..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Install Node.js from NodeSource
echo "Installing Node.js..."
sudo apt install -y nodejs

# Install NVM for version management
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install latest Node.js version through NVM as well
nvm install node
nvm install --lts
nvm use --lts

# Update npm to latest version
echo "Updating npm..."
npm install -g npm@latest

# Install common global npm packages
echo "Installing global npm packages..."
npm install -g \
    yarn \
    pnpm \
    nx \
    @angular/cli \
    @vue/cli \
    create-react-app \
    create-next-app \
    typescript \
    ts-node \
    nodemon \
    pm2 \
    serve \
    http-server \
    eslint \
    prettier \
    npm-check-updates \
    typeorm \
    prisma \
    sequelize-cli \
    express-generator \
    gatsby-cli \
    @nestjs/cli \
    firebase-tools \
    vercel \
    netlify-cli \
    @sanity/cli

# Add NVM init to shell configurations
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc

# If fish shell is installed, set up NVM in fish
if command -v fish &> /dev/null; then
    mkdir -p ~/.config/fish/functions
    curl -o ~/.config/fish/functions/nvm.fish -sL https://raw.githubusercontent.com/jorgebucaran/nvm.fish/main/functions/nvm.fish
fi

# Create .npmrc with some useful defaults
echo "Setting up npm configuration..."
echo "save-exact=true
package-lock=true
fund=false
audit=false" > ~/.npmrc

echo "Node.js installation complete! Installed packages and tools:
- Node.js (system): $(node --version)
- NVM: $(nvm --version)
- npm: $(npm --version)
- yarn: $(yarn --version 2>/dev/null || echo 'not verified')
- pnpm: $(pnpm --version 2>/dev/null || echo 'not verified')

Global packages installed:
- Angular CLI (@angular/cli)
- Vue CLI (@vue/cli)
- Create React App
- Next.js (create-next-app)
- TypeScript & ts-node
- Nodemon (auto-reloading)
- PM2 (process manager)
- Serve & http-server
- ESLint & Prettier
- npm-check-updates
- TypeORM & Prisma & Sequelize
- Express Generator
- Gatsby CLI
- NestJS CLI
- Firebase Tools
- Vercel & Netlify CLI
- Sanity CLI

You can manage Node.js versions using:
nvm install <version>    # Install a specific version
nvm use <version>       # Use a specific version
nvm alias default <version>  # Set default version
nvm list               # List installed versions"
