To really use this well, you need a good terminal emulator like wezterm (otherwise colors and fonts will be like bleh)

On Debian/Ubuntu, `setup.sh` automates everything below. On macOS, `setup-mac.sh` does the same via Homebrew (installs Homebrew if missing, brew-installs the CLI tools, sets up Oh My Zsh/p10k/plugins, tpm, MesloLGS NF fonts in ~/Library/Fonts, and stows the dotfiles). Both scripts are safe to re-run.

Install git, neovim, eza, zoxide, tmux, stow, fzf, fd (Debian/Ubuntu package name: fd-find), bat/batcat, git-delta, tldr (or tlrc), and ripgrep via the package manager.
Install pipx so you can install thefuck cleanly:
sudo apt install pipx
pipx ensurepath
pipx install thefuck
After installing, run `source ~/.zshrc` to pick up aliases/keybindings.

Install Oh My Zsh:
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

Install PowerLevel10k Theme for Oh My Zsh:
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

Install zsh-autosuggestions:
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

Install zsh-syntax-highlighting:
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

Install fzf (package manager provides the scripts):
sudo apt install fzf
Install fd for faster fzf results (Debian/Ubuntu package name is fd-find so the binary is fdfind; ~/.zshrc aliases fd→fdfind):
sudo apt install fd-find
Install fzf git helpers:
git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git.sh

fzf/zsh setup already in ~/.zshrc:
- loads fzf key bindings/completion (prefers `eval "$(fzf --zsh)"`, falls back to /usr/share/doc/fzf/examples)
- uses fd as the default source for files/dirs when present
- enables previews with bat/batcat (files) and eza (directories), plus ssh/export previews
- applies a custom theme via FZF_DEFAULT_OPTS
- sources ~/fzf-git.sh/fzf-git.sh if present for git pickers

Install tmux plugin manager:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

After installing the plugin manager, run tmux then do prefix + I to install the plugins

Optional extras from the post:
- bat theme: download a theme (e.g. tokyonight) into "$(bat --config-dir)/themes", run `bat cache --build`, then set `export BAT_THEME=your_theme` in ~/.zshrc if you want it.
- git delta: block from the blog is already in ~/.gitconfig; if you reset it, re-add the delta section from the post.
- thefuck: prefer `pipx install thefuck` (Debian package can be broken); ~/.zshrc wires `fuck` and `fk` aliases once the command exists.
- tldr/tlrc: install the client and use `tldr <command>` for quick examples.
