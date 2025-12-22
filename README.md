# dotfiles

dotfiles for Ubuntu server environment with zsh, neovim, and tmux.

## Quick Start

```bash
./setup-init.sh

# This interactive script will install:
# - **Basic packages**: git, curl, build-essential, development libraries
# - **zsh**: Modern shell (migrates from bash)
# - **starship**: Cross-shell prompt
# - **pyenv** + Python (version selectable)
# - **nodenv** + Node.js (version selectable)
# - **neovim** (built from source - stable branch)
# - **tmux**

./setup-config.sh

# This script will:
# - Symlink dotfiles from `home/` to `~/`
# - Symlink configs from `.config/` to `~/.config/`
# - Create local config templates (`*.local` files)
```


## Repository Structure

```
dotfiles/
├── home/                      # Home directory dotfiles
│   ├── .zshenv               # Environment variables (all shells)
│   ├── .zprofile             # Login shell PATH and tool init
│   ├── .zshrc                # Interactive shell config
│   └── .tmux.conf            # Tmux configuration
├── .config/                   # XDG config directory
│   ├── alacritty/            # Alacritty terminal
│   ├── direnv/               # Directory-specific env
│   ├── git/                  # Git global config
│   ├── kitty/                # Kitty terminal
│   ├── lazygit/              # LazyGit TUI
│   ├── nvim/                 # Neovim (Lua-based, 40+ plugins)
│   └── starship.toml         # Starship prompt
├── zsh-templates/             # Templates for local configs
│   ├── .zshenv.local.template
│   ├── .zprofile.local.template
│   └── .zshrc.local.template
├── .scripts/                  # Utility scripts
│   └── ide.sh                # Tmux IDE-like layout
├── setup-init.sh             # Initial setup script
├── setup-config.sh           # Config symlink script
└── README.md
```
