To really use this well, you need a good terminal emulator like wezterm (otherwise colors and fonts will be like bleh)

Install git, neovim, eza, zoxide, tmux, stow via the package manager.

Install Oh My Zsh:
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

Install PowerLevel10k Theme for Oh My Zsh:
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

Install zsh-autosuggestions:
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

Install zsh-syntax-highlighting:
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

Install tmux plugin manager:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
