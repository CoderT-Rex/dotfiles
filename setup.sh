#!/bin/bash

# Dotfiles Setup Script
# This script installs all dependencies and configures the environment

set -e  # Exit on error

echo "========================================="
echo "Starting dotfiles setup..."
echo "========================================="

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install basic packages
echo "Installing packages via apt..."
sudo apt-get install -y git tmux stow fzf ripgrep zoxide zsh curl wget unzip

# Install eza
echo "Installing eza..."
if ! command -v eza &> /dev/null; then
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

# Install Neovim
echo "Installing Neovim..."
NVIM_VERSION="v0.10.2"
cd /tmp
wget https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
sudo rm -f /usr/local/bin/nvim
sudo rm -rf /opt/nvim
sudo mv squashfs-root /opt/nvim
sudo ln -s /opt/nvim/usr/bin/nvim /usr/local/bin/nvim
cd -

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install PowerLevel10k theme
echo "Installing PowerLevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Install zsh-syntax-highlighting
echo "Installing zsh-syntax-highlighting..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install tmux plugin manager
echo "Installing tmux plugin manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install Nerd Fonts
echo "Installing MesloLGS NF fonts..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv
cd -

# Stow dotfiles
echo "Stowing dotfiles..."
cd ~/dotfiles
# Remove any existing conflicting files
rm -f ~/.zshrc ~/.tmux.conf ~/.p10k.zsh
stow .
cd -

# Set zsh as default shell
echo "Setting zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "Default shell changed to zsh. You'll need to log out and back in for this to take effect."
fi

echo "========================================="
echo "Setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Log out and log back in (or restart your terminal)"
echo "2. If using WezTerm on Windows/WSL, install the fonts on Windows:"
echo "   - Fonts are in ~/.local/share/fonts/"
echo "   - Copy them to Windows and install"
echo "   - Configure WezTerm to use 'MesloLGS NF' font"
echo "3. In tmux, press prefix + I (Ctrl+b then I) to install tmux plugins"
echo "4. Enjoy your setup!"
