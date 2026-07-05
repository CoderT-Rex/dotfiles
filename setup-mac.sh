#!/bin/bash

# Dotfiles Setup Script (macOS)
# Mirrors setup.sh (Debian/Ubuntu) but uses Homebrew instead of apt.
# Safe to re-run; each step is idempotent.

set -e

echo "========================================="
echo "Starting dotfiles setup (macOS)..."
echo "========================================="

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available in this script's shell (Apple Silicon vs Intel path)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Install packages
echo "Installing packages via brew..."
brew install git neovim tmux stow fzf fd ripgrep eza zoxide bat git-delta tlrc pipx

# Install thefuck (prefer default python; fall back to python@3.11 if the
# default Homebrew python is too new for thefuck's use of distutils)
echo "Installing thefuck..."
pipx ensurepath
if ! command -v fuck &> /dev/null; then
    pipx install thefuck || true
fi
if ! PATH="$HOME/.local/bin:$PATH" fuck --version &> /dev/null; then
    echo "Default python incompatible with thefuck, retrying with python@3.11..."
    brew install python@3.11
    pipx uninstall thefuck || true
    pipx install --python /opt/homebrew/opt/python@3.11/bin/python3.11 thefuck
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install PowerLevel10k theme
echo "Installing PowerLevel10k theme..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting
echo "Installing zsh-syntax-highlighting..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install fzf-git.sh (used by ~/.zshrc if present)
echo "Installing fzf-git.sh..."
if [ ! -d "$HOME/fzf-git.sh" ]; then
    git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git.sh
fi

# Install tmux plugin manager
echo "Installing tmux plugin manager..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install MesloLGS NF fonts (macOS auto-registers fonts dropped into ~/Library/Fonts)
echo "Installing MesloLGS NF fonts..."
mkdir -p ~/Library/Fonts
cd ~/Library/Fonts
curl -fLo "MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -fLo "MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl -fLo "MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl -fLo "MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
cd -

# Stow dotfiles, backing up anything already in place
echo "Stowing dotfiles..."
cd ~/dotfiles
backup_suffix=".bak-$(date +%Y%m%d%H%M%S)"
for f in .zshrc .tmux.conf .p10k.zsh; do
    if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
        echo "Backing up existing ~/$f to ~/$f$backup_suffix"
        mv "$HOME/$f" "$HOME/$f$backup_suffix"
    fi
done
stow .
cd -

echo "========================================="
echo "Setup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Restart your terminal (or open a new WezTerm tab) to load the new shell config."
echo "2. In WezTerm, set the font to 'MesloLGS NF' (fonts were installed to ~/Library/Fonts)."
echo "3. In tmux, press prefix + I (Ctrl+b then I) to install tmux plugins."
echo "4. Enjoy your setup!"
