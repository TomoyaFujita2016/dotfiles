#!/bin/bash

# ============================================================================
# Ubuntu Server Initial Setup Script
# ============================================================================
# This script sets up development tools and version managers on Ubuntu server.
# - pyenv + Python
# - nodenv + Node.js
# - neovim (build from source)
# - tmux
# - Basic development packages
# ============================================================================

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# ────────────────────────────────────────────────────────────────────────────
# Color Codes and Logging Functions
# ────────────────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# ────────────────────────────────────────────────────────────────────────────
# Global Variables
# ────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.dotfiles-backup/${TIMESTAMP}"

# Installation flags (set by user interaction)
INSTALL_BASIC="false"
INSTALL_ZSH="false"
INSTALL_STARSHIP="false"
INSTALL_PYENV="false"
INSTALL_NODENV="false"
INSTALL_NEOVIM="false"
INSTALL_TMUX="false"
CHANGE_SHELL="false"

# Version selections
PYTHON_VERSION=""
NODE_VERSION=""

# Installation results tracking
declare -A INSTALL_STATUS

# ────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ────────────────────────────────────────────────────────────────────────────

get_latest_python_version() {
    # Get latest stable Python version from pyenv
    if [ -d "$HOME/.pyenv" ]; then
        timeout 30 ~/.pyenv/bin/pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ' || echo "3.12.7"
    else
        echo "3.12.7"  # Fallback
    fi
}

get_latest_node_version() {
    # Get latest stable Node version from nodenv
    if [ -d "$HOME/.nodenv" ]; then
        timeout 30 ~/.nodenv/bin/nodenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ' || echo "20.18.0"
    else
        echo "20.18.0"  # Fallback to LTS
    fi
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

prompt_yes_no() {
    local prompt_message="$1"
    local default_response="${2:-Y}"
    local response

    read -p "$prompt_message" response
    response=${response:-$default_response}

    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

check_already_installed() {
    local tool_name="$1"
    local check_type="${2:-command}"  # command, directory, or file
    local check_target="${3:-$tool_name}"

    case "$check_type" in
        command)
            if check_command "$check_target"; then
                log_info "$tool_name already installed"
                "$check_target" --version 2>/dev/null || echo "Version check not available"
                return 0
            fi
            ;;
        directory)
            if [ -d "$check_target" ]; then
                log_info "$tool_name already installed, skipping clone"
                return 0
            fi
            ;;
        file)
            if [ -f "$check_target" ]; then
                log_info "$tool_name already exists"
                return 0
            fi
            ;;
    esac
    return 1
}

# ────────────────────────────────────────────────────────────────────────────
# Interactive Interface
# ────────────────────────────────────────────────────────────────────────────

show_welcome() {
    echo ""
    echo "========================================"
    echo "  Ubuntu Server Initial Setup"
    echo "========================================"
    echo ""
    echo "This script will help you set up:"
    echo "  • Basic development packages"
    echo "  • zsh (shell migration from bash)"
    echo "  • starship (prompt)"
    echo "  • pyenv + Python"
    echo "  • nodenv + Node.js"
    echo "  • neovim (from source)"
    echo "  • tmux"
    echo ""
    echo "Note: zinit (zsh plugin manager) will be"
    echo "      auto-installed when you first run zsh"
    echo ""
}

select_tools() {
    log_step "Tool Selection"
    echo ""

    # Basic packages
    if prompt_yes_no "Install basic packages (git, curl, build-essential, etc.)? [Y/n]: "; then
        INSTALL_BASIC="true"
    fi

    # zsh
    echo ""
    if prompt_yes_no "Install zsh and migrate from bash? [Y/n]: "; then
        INSTALL_ZSH="true"
        if prompt_yes_no "  Change default shell to zsh? [Y/n]: "; then
            CHANGE_SHELL="true"
        fi
    fi

    # starship (prompt)
    echo ""
    if prompt_yes_no "Install starship (modern prompt)? [Y/n]: "; then
        INSTALL_STARSHIP="true"
    fi

    # pyenv + Python
    echo ""
    if prompt_yes_no "Install pyenv + Python? [Y/n]: "; then
        INSTALL_PYENV="true"
        echo "  Select Python version:"
        echo "    1) latest ($(get_latest_python_version))"
        echo "    2) 3.11.x"
        echo "    3) 3.10.x"
        echo "    4) skip"
        read -p "  Choice [1-4]: " choice
        case $choice in
            1) PYTHON_VERSION=$(get_latest_python_version) ;;
            2) PYTHON_VERSION="3.11.10" ;;
            3) PYTHON_VERSION="3.10.15" ;;
            4) INSTALL_PYENV="false" ;;
            *) PYTHON_VERSION=$(get_latest_python_version) ;;
        esac
    fi

    # nodenv + Node.js
    echo ""
    if prompt_yes_no "Install nodenv + Node.js? [Y/n]: "; then
        INSTALL_NODENV="true"
        echo "  Select Node version:"
        echo "    1) latest ($(get_latest_node_version))"
        echo "    2) 20.x (LTS)"
        echo "    3) 18.x (LTS)"
        echo "    4) skip"
        read -p "  Choice [1-4]: " choice
        case $choice in
            1) NODE_VERSION=$(get_latest_node_version) ;;
            2) NODE_VERSION="20.18.0" ;;
            3) NODE_VERSION="18.20.5" ;;
            4) INSTALL_NODENV="false" ;;
            *) NODE_VERSION=$(get_latest_node_version) ;;
        esac
    fi

    # neovim
    echo ""
    if prompt_yes_no "Install neovim (build from source)? [Y/n]: "; then
        INSTALL_NEOVIM="true"
    fi

    # tmux
    echo ""
    if prompt_yes_no "Install tmux? [Y/n]: "; then
        INSTALL_TMUX="true"
    fi
}

confirm_selections() {
    echo ""
    echo "========================================"
    echo "  Installation Summary"
    echo "========================================"
    [ "$INSTALL_BASIC" = "true" ] && echo "✓ Basic packages"
    [ "$INSTALL_ZSH" = "true" ] && echo "✓ zsh"
    [ "$CHANGE_SHELL" = "true" ] && echo "  └─ Change default shell to zsh"
    [ "$INSTALL_STARSHIP" = "true" ] && echo "✓ starship (prompt)"
    [ "$INSTALL_PYENV" = "true" ] && echo "✓ pyenv (Python $PYTHON_VERSION)"
    [ "$INSTALL_NODENV" = "true" ] && echo "✓ nodenv (Node $NODE_VERSION)"
    [ "$INSTALL_NEOVIM" = "true" ] && echo "✓ neovim (build from source - stable)"
    [ "$INSTALL_TMUX" = "true" ] && echo "✓ tmux"
    echo ""
    [ "$INSTALL_ZSH" = "true" ] && echo "Note: zinit will auto-install on first zsh run"
    echo ""

    if prompt_yes_no "Proceed with installation? [Y/n]: "; then
        return 0
    else
        log_warn "Installation cancelled by user"
        return 1
    fi
}

# ────────────────────────────────────────────────────────────────────────────
# Installation Functions
# ────────────────────────────────────────────────────────────────────────────

install_basic_packages() {
    log_step "Installing basic development packages..."

    sudo apt-get update || { log_error "Failed to update package list"; return 1; }

    sudo apt-get install -y \
        git curl wget \
        build-essential \
        libssl-dev libreadline-dev \
        zlib1g-dev libbz2-dev libsqlite3-dev \
        libffi-dev liblzma-dev \
        unzip zip \
        software-properties-common || { log_error "Failed to install basic packages"; return 1; }

    log_info "Basic packages installed successfully"
    INSTALL_STATUS[basic]="success"
    return 0
}

install_zsh() {
    log_step "Installing zsh..."

    # Check if already installed
    if check_command zsh; then
        log_info "zsh already installed"
        zsh --version
        INSTALL_STATUS[zsh]="already_exists"
        return 0
    fi

    # Install zsh
    sudo apt-get install -y zsh || { log_error "Failed to install zsh"; return 1; }

    log_info "zsh installed successfully"
    zsh --version
    INSTALL_STATUS[zsh]="success"

    return 0
}

change_default_shell() {
    log_step "Changing default shell to zsh..."

    # Get current shell
    local current_shell=$(basename "$SHELL")
    if [ "$current_shell" = "zsh" ]; then
        log_info "Default shell is already zsh"
        return 0
    fi

    # Get zsh path and validate it
    local zsh_path
    zsh_path=$(command -v zsh)
    if [ -z "$zsh_path" ]; then
        log_error "zsh not found in PATH"
        return 1
    fi

    # Validate zsh_path to prevent command injection
    # Must be an absolute path and exist in /etc/shells
    if [[ ! "$zsh_path" =~ ^/ ]]; then
        log_error "Invalid zsh path (not absolute): $zsh_path"
        return 1
    fi

    if ! grep -q "^${zsh_path}$" /etc/shells 2>/dev/null; then
        log_warn "zsh path not in /etc/shells, adding it..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null || {
            log_error "Failed to add zsh to /etc/shells"
            return 1
        }
    fi

    # Change shell
    log_info "Changing shell to $zsh_path"

    # Try with sudo first (works in Docker/test environments with NOPASSWD)
    if sudo -n chsh -s "$zsh_path" "$USER" 2>/dev/null; then
        log_info "Default shell changed to zsh (via sudo)"
        log_warn "Please log out and log back in for the change to take effect"
        INSTALL_STATUS[shell_change]="success"
    else
        # Fall back to regular chsh (requires user password)
        log_warn "You may need to enter your password"
        if chsh -s "$zsh_path"; then
            log_info "Default shell changed to zsh"
            log_warn "Please log out and log back in for the change to take effect"
            INSTALL_STATUS[shell_change]="success"
        else
            log_error "Failed to change default shell"
            log_warn "You can manually change shell later with: chsh -s $zsh_path"
            INSTALL_STATUS[shell_change]="failed"
            return 1
        fi
    fi

    return 0
}

install_starship() {
    log_step "Installing starship (prompt)..."

    # Check if already installed
    if check_command starship; then
        log_info "starship already installed"
        starship --version
        INSTALL_STATUS[starship]="already_exists"
        return 0
    fi

    # Install starship using official installer with security measures
    log_info "Downloading starship installer..."
    local installer_path="/tmp/starship-install-$$.sh"

    # Download installer with timeout and retry
    curl --connect-timeout 10 --retry 3 --retry-delay 2 -fsSL https://starship.rs/install.sh -o "$installer_path" || {
        log_error "Failed to download starship installer"
        rm -f "$installer_path"
        return 1
    }

    # Verify downloaded file is not empty and looks like a shell script
    if [ ! -s "$installer_path" ]; then
        log_error "Downloaded installer is empty"
        rm -f "$installer_path"
        return 1
    fi

    if ! head -1 "$installer_path" | grep -q '^#!/'; then
        log_error "Downloaded file does not appear to be a shell script"
        rm -f "$installer_path"
        return 1
    fi

    log_info "Installing starship..."
    sh "$installer_path" -y || {
        log_error "Failed to install starship"
        rm -f "$installer_path"
        return 1
    }

    # Clean up
    rm -f "$installer_path"

    log_info "starship installed successfully"
    starship --version
    INSTALL_STATUS[starship]="success"

    return 0
}

install_pyenv() {
    log_step "Installing pyenv and Python ${PYTHON_VERSION}..."

    # Check if already installed
    if [ -d "$HOME/.pyenv" ]; then
        log_info "pyenv already installed, skipping clone"
        INSTALL_STATUS[pyenv]="already_exists"
    else
        # Clone pyenv
        log_info "Cloning pyenv repository..."
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv || { log_error "Failed to clone pyenv"; return 1; }
        INSTALL_STATUS[pyenv]="success"
    fi

    # Install Python build dependencies
    log_info "Installing Python build dependencies..."
    sudo apt-get install -y \
        libbz2-dev libreadline-dev libsqlite3-dev \
        libssl-dev zlib1g-dev libffi-dev liblzma-dev \
        tk-dev libxml2-dev libxmlsec1-dev liblzma-dev || { log_warn "Some build dependencies failed to install"; }

    # Install Python version
    log_info "Installing Python ${PYTHON_VERSION}..."
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"

    ~/.pyenv/bin/pyenv install -s ${PYTHON_VERSION} || { log_error "Failed to install Python ${PYTHON_VERSION}"; return 1; }
    ~/.pyenv/bin/pyenv global ${PYTHON_VERSION}

    # Verify Python installation using pyenv shims
    log_info "Python ${PYTHON_VERSION} installed successfully"
    ~/.pyenv/shims/python --version || python --version

    return 0
}

install_nodenv() {
    log_step "Installing nodenv and Node ${NODE_VERSION}..."

    # Check if already installed
    if [ -d "$HOME/.nodenv" ]; then
        log_info "nodenv already installed, skipping clone"
        INSTALL_STATUS[nodenv]="already_exists"
    else
        # Clone nodenv
        log_info "Cloning nodenv repository..."
        git clone https://github.com/nodenv/nodenv.git ~/.nodenv || { log_error "Failed to clone nodenv"; return 1; }

        # Clone node-build plugin
        log_info "Installing node-build plugin..."
        git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build || { log_warn "Failed to install node-build plugin"; }

        INSTALL_STATUS[nodenv]="success"
    fi

    # Install Node version
    log_info "Installing Node ${NODE_VERSION}..."
    export PATH="$HOME/.nodenv/bin:$PATH"
    eval "$(nodenv init -)"

    ~/.nodenv/bin/nodenv install -s ${NODE_VERSION} || { log_error "Failed to install Node ${NODE_VERSION}"; return 1; }
    ~/.nodenv/bin/nodenv global ${NODE_VERSION}

    log_info "Node ${NODE_VERSION} installed successfully"
    node --version

    return 0
}

install_neovim() {
    log_step "Building and installing neovim from source..."

    # Install build dependencies
    log_info "Installing neovim build dependencies..."
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential || { log_error "Failed to install neovim dependencies"; return 1; }

    # Setup source directory
    local nvim_dir="$HOME/.local/src/neovim"
    if [ -d "$nvim_dir" ]; then
        log_info "Neovim source already exists, updating..."
        cd "$nvim_dir"
        git fetch
        INSTALL_STATUS[neovim]="updated"
    else
        log_info "Cloning neovim repository..."
        mkdir -p "$HOME/.local/src"
        git clone https://github.com/neovim/neovim.git "$nvim_dir" || { log_error "Failed to clone neovim"; return 1; }
        cd "$nvim_dir"
        INSTALL_STATUS[neovim]="success"
    fi

    # Checkout stable branch
    log_info "Checking out stable release..."
    git checkout stable || { log_error "Failed to checkout stable branch"; return 1; }
    git pull origin stable

    # Clean previous build
    make distclean 2>/dev/null || true

    # Build neovim
    log_info "Building neovim (this may take a few minutes)..."
    make CMAKE_BUILD_TYPE=RelWithDebInfo || { log_error "Failed to build neovim"; return 1; }

    # Install neovim
    log_info "Installing neovim..."
    sudo make install || { log_error "Failed to install neovim"; return 1; }

    log_info "Neovim installed successfully!"
    nvim --version | head -1

    return 0
}

install_tmux() {
    log_step "Installing tmux..."

    sudo apt-get install -y tmux || { log_error "Failed to install tmux"; return 1; }

    log_info "tmux installed successfully"
    tmux -V
    INSTALL_STATUS[tmux]="success"

    return 0
}

# ────────────────────────────────────────────────────────────────────────────
# Configuration Update Functions
# ────────────────────────────────────────────────────────────────────────────

update_zsh_configs() {
    log_step "Updating zsh configuration files..."

    local zprofile_file="$SCRIPT_DIR/home/.zprofile"

    # Check if file exists
    if [ ! -f "$zprofile_file" ]; then
        log_warn "Warning: $zprofile_file not found, skipping update"
        return 0
    fi

    # Create backup
    log_info "Creating backup: ${zprofile_file}.backup_${TIMESTAMP}"
    cp "$zprofile_file" "${zprofile_file}.backup_${TIMESTAMP}"

    # Check if pyenv init is already enhanced
    if grep -q 'eval "$(pyenv init -)"' "$zprofile_file"; then
        log_info "pyenv initialization already enhanced, skipping"
    else
        log_info "Enhancing pyenv initialization in .zprofile..."
        # Add pyenv init - after pyenv init --path
        sed -i '/eval "$(pyenv init --path)"/a \  eval "$(pyenv init -)"' "$zprofile_file"

        # Verify the modification was successful
        if grep -q 'eval "$(pyenv init -)"' "$zprofile_file"; then
            log_info "Enhanced pyenv initialization in .zprofile"
        else
            log_error "Failed to enhance pyenv initialization in .zprofile"
            return 1
        fi
    fi

    return 0
}

# ────────────────────────────────────────────────────────────────────────────
# Installation Report
# ────────────────────────────────────────────────────────────────────────────

show_installation_report() {
    echo ""
    echo "========================================"
    echo "  Installation Report"
    echo "========================================"

    for tool in "${!INSTALL_STATUS[@]}"; do
        status="${INSTALL_STATUS[$tool]}"
        case $status in
            success)
                echo "✓ $tool: Installed successfully"
                ;;
            already_exists)
                echo "→ $tool: Already installed (skipped)"
                ;;
            updated)
                echo "↻ $tool: Updated"
                ;;
            failed)
                echo "✗ $tool: Installation failed"
                ;;
        esac
    done

    echo ""
}

# ────────────────────────────────────────────────────────────────────────────
# Main Function
# ────────────────────────────────────────────────────────────────────────────

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_error "Do not run this script as root. It will use sudo when needed."
        exit 1
    fi

    # Show welcome message
    show_welcome

    # Interactive tool selection
    select_tools

    # Confirm selections
    confirm_selections || exit 0

    echo ""
    log_info "Starting installation..."
    echo ""

    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    log_info "Backup directory: $BACKUP_DIR"
    echo ""

    # Run installations
    if [ "$INSTALL_BASIC" = "true" ]; then
        install_basic_packages || INSTALL_STATUS[basic]="failed"
        echo ""
    fi

    if [ "$INSTALL_ZSH" = "true" ]; then
        install_zsh || INSTALL_STATUS[zsh]="failed"
        echo ""
    fi

    if [ "$CHANGE_SHELL" = "true" ]; then
        change_default_shell || INSTALL_STATUS[shell_change]="failed"
        echo ""
    fi

    if [ "$INSTALL_STARSHIP" = "true" ]; then
        install_starship || INSTALL_STATUS[starship]="failed"
        echo ""
    fi

    if [ "$INSTALL_PYENV" = "true" ]; then
        install_pyenv || INSTALL_STATUS[pyenv]="failed"
        echo ""
    fi

    if [ "$INSTALL_NODENV" = "true" ]; then
        install_nodenv || INSTALL_STATUS[nodenv]="failed"
        echo ""
    fi

    if [ "$INSTALL_NEOVIM" = "true" ]; then
        install_neovim || INSTALL_STATUS[neovim]="failed"
        echo ""
    fi

    if [ "$INSTALL_TMUX" = "true" ]; then
        install_tmux || INSTALL_STATUS[tmux]="failed"
        echo ""
    fi

    # Update zsh configs
    update_zsh_configs
    echo ""

    # Show installation report
    show_installation_report

    # Next steps
    echo "========================================"
    echo "  Next Steps"
    echo "========================================"
    echo ""

    if [ "$CHANGE_SHELL" = "true" ]; then
        log_warn "IMPORTANT: You changed your default shell to zsh"
        log_warn "Please log out and log back in for the change to take effect"
        echo ""
    fi

    echo "1. Run: ./setup-config.sh"
    echo "   This will create symlinks and local config files"
    echo ""
    echo "2. Edit local configs with your values:"
    echo "   - ~/.zshenv.local (API keys, secrets)"
    echo "   - ~/.zprofile.local (PATH additions)"
    echo "   - ~/.zshrc.local (aliases, functions)"
    echo ""

    if [ "$CHANGE_SHELL" = "true" ]; then
        echo "3. Log out and log back in (shell changed to zsh)"
        echo ""
        echo "4. After logging back in, verify with:"
        echo "   echo \$SHELL"
    else
        echo "3. Start zsh manually:"
        echo "   zsh"
        echo ""
        echo "   Or restart your shell:"
        echo "   exec zsh"
    fi

    echo ""
    log_info "Setup initialization completed!"
    echo ""
}

# Run main function
main
