# dotfiles

Personal dotfiles for Ubuntu server environment with zsh, neovim, and tmux.

## Quick Start

For a fresh Ubuntu server, follow these steps:

### 1. Initial Setup (First Time Only)

Install development tools and version managers:

```bash
./setup-init.sh
```

This interactive script will install:
- **Basic packages**: git, curl, build-essential, development libraries
- **zsh**: Modern shell (migrates from bash)
- **starship**: Cross-shell prompt
- **pyenv** + Python (version selectable)
- **nodenv** + Node.js (version selectable)
- **neovim** (built from source - stable branch)
- **tmux**

> **Note**: zinit (zsh plugin manager) will be **auto-installed** when you first run zsh (configured in `.zshrc`)

### 2. Configuration Setup

Create symbolic links and local config files:

```bash
./setup-config.sh
```

This script will:
- Symlink dotfiles from `home/` to `~/`
- Symlink configs from `.config/` to `~/.config/`
- Create local config templates (`*.local` files)

### 3. Customize Local Settings

Edit the generated local config files:

```bash
# Sensitive data (API keys, tokens)
vi ~/.zshenv.local

# PC-specific PATH and initialization
vi ~/.zprofile.local

# PC-specific aliases and functions
vi ~/.zshrc.local
```

### 4. Apply Changes

**If you changed default shell to zsh:**
```bash
# Log out and log back in
exit

# After logging back in, verify:
echo $SHELL  # Should show /usr/bin/zsh or /bin/zsh
```

**If you didn't change default shell:**
```bash
# Start zsh manually
zsh

# Or restart shell (if already in zsh)
exec zsh
```

## 📂 Repository Structure

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

## 🔧 Setup Scripts

### setup-init.sh

**Purpose**: Install development tools and version managers on fresh Ubuntu server

**Features**:
- Interactive tool selection (skip what you don't need)
- **Bash to zsh migration** with automatic shell change option
- Version selection for Python and Node.js
- Idempotent (safe to run multiple times)
- Automatic backup of config files
- Builds neovim from source for latest stable version

**Usage**:
```bash
# Interactive mode
./setup-init.sh

# The script will prompt for each tool and version
```

### setup-config.sh

**Purpose**: Create symbolic links and set up local configuration files

**Features**:
- Symlinks `home/` dotfiles to `~/`
- Symlinks `.config/` to `~/.config/`
- Creates `*.local` files from templates
- Backs up existing files with timestamp
- Idempotent and safe

**Usage**:
```bash
./setup-config.sh
```

> **Note**: If a configuration file already exists, it will be renamed to `{filename}.org_{timestamp}` before creating the symlink.

## 🛠️ Tools & Features

### Shell (zsh)
- **Migration**: Automated bash → zsh migration with `chsh`
- **Plugin Manager**: zinit (lazy-loaded plugins)
- **Prompt**: Starship (fast, customizable)
- **Version Managers**: pyenv, nodenv
- **Local Configs**: Separate `*.local` files for PC-specific settings
- **History**: Shared history across sessions with deduplication

### Editor (neovim)
- **Plugin Manager**: lazy.nvim
- **LSP**: Native LSP with nvim-lspconfig
- **Completion**: nvim-cmp
- **40+ Plugins**: Including copilot, telescope, treesitter, and more

### Terminal Multiplexer (tmux)
- **Prefix**: `C-q` (custom, not default `C-b`)
- **Vi Keybindings**: Vim-style navigation
- **SSH-Aware Clipboard**: OSC 52 for remote sessions
- **Mouse Support**: Disabled by default

## 📝 Configuration Philosophy

### Three-Tier Config System

1. **Repository Configs** (tracked in git)
   - `home/.zshenv`, `home/.zprofile`, `home/.zshrc`
   - `home/.tmux.conf`
   - `.config/nvim/`, `.config/*/`

2. **Local Configs** (excluded from git)
   - `~/.zshenv.local` - API keys, secrets
   - `~/.zprofile.local` - PC-specific PATH, version overrides
   - `~/.zshrc.local` - PC-specific aliases, functions

3. **Templates** (tracked in git)
   - `zsh-templates/*.template` - Starting point for local configs

### Environment Variables

**Defined in `.zshenv`**:
- `EDITOR=nvim`, `VISUAL=nvim`
- XDG Base Directory variables
- `PYENV_ROOT`, `CARGO_HOME`

**Defined in `.zprofile`**:
- PATH configuration with deduplication
- Tool initialization (pyenv, nodenv)

## 🔄 Version Manager Configuration

### pyenv (Python)

```bash
# Check available versions
pyenv install --list

# Install specific version
pyenv install 3.11.10

# Set global version
pyenv global 3.11.10

# Set project-specific version
pyenv local 3.10.15
```

### nodenv (Node.js)

```bash
# Check available versions
nodenv install --list

# Install specific version
nodenv install 20.18.0

# Set global version
nodenv global 20.18.0

# Set project-specific version
nodenv local 18.20.5
```

### Version Override in ~/.zprofile.local

```bash
# Force specific Python version
export PYENV_VERSION=3.11.0

# Force specific Node version
export NODENV_VERSION=20.0.0
```

## 🧪 Testing Setup

To test the complete setup on a fresh Ubuntu 22.04:

```bash
# 1. Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Run initial setup
./setup-init.sh

# 3. Run config setup
./setup-config.sh

# 4. Edit local configs
vi ~/.zshenv.local
vi ~/.zprofile.local
vi ~/.zshrc.local

# 5. Restart shell
exec zsh

# 6. Verify installations
pyenv --version
nodenv --version
python --version
node --version
nvim --version
tmux -V
```

## ⚠️ Important Notes

- **Root Access**: Do NOT run `setup-init.sh` as root. It will use `sudo` when needed.
- **Shell Change**: If you change default shell to zsh, you MUST log out and log back in
- **Backup**: Both scripts automatically backup existing files with timestamps
- **Idempotent**: Safe to run multiple times - existing installations are detected and skipped
- **Neovim**: Built from source (stable branch) for latest features
- **SSH Sessions**: Tmux clipboard works via OSC 52 for remote access

## 🔄 Bash to Zsh Migration

The `setup-init.sh` script handles the complete migration:

1. **Installs zsh** if not present
2. **Optionally changes default shell** using `chsh`
3. **Installs starship** for modern prompt
4. **zinit auto-installs** on first zsh run (via `.zshrc`)

After migration, your existing bash aliases and functions can be moved to:
- `~/.zshrc.local` for zsh-specific functions
- `~/.zprofile.local` for PATH modifications

**Note**: Bash-specific syntax (like `[[` conditional expressions) works in zsh, but zsh offers additional features like glob qualifiers and advanced completion.

## 📄 License

MIT
