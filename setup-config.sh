#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Get current script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Timestamp for backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Function to create a symbolic link
create_symlink() {
    local source="$1"
    local target="$2"

    # Create target directory if it does not exist
    target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        log_info "Created directory: $target_dir"
    fi

    # Process when target already exists
    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            # Skip if existing symlinks point to the same location
            current_link=$(readlink "$target")
            if [ "$current_link" == "$source" ]; then
                log_info "Symlink already exists and points to the correct location: $target -> $source"
                return
            fi
        fi

        # Create backup
        backup_path="${target}.org_${TIMESTAMP}"
        mv "$target" "$backup_path"
        log_warn "Existing file backed up: $backup_path"
    fi

    # Create symbolic link
    ln -s "$source" "$target"
    log_info "Created symlink: $target -> $source"
}

# Function to setup local config files from templates
setup_local_config() {
    local template_path="$1"
    local target_path="$2"

    # Skip if local config already exists
    if [ -e "$target_path" ]; then
        log_info "Local config already exists, skipping: $target_path"
        return
    fi

    # Copy template to local config
    if [ -e "$template_path" ]; then
        cp "$template_path" "$target_path"
        chmod 600 "$target_path"  # Secure permissions for sensitive files
        log_info "Created local config from template: $target_path"
        log_warn "Please edit $target_path and add your actual values"
    fi
}

main() {
    log_info "Starting config setup..."

    # Setup home directory dotfiles
    log_info "Setting up home directory dotfiles..."
    if [ -d "$SCRIPT_DIR/home" ]; then
        for dotfile in "$SCRIPT_DIR"/home/.*; do
            # Skip . and ..
            if [ "$(basename "$dotfile")" = "." ] || [ "$(basename "$dotfile")" = ".." ]; then
                continue
            fi

            if [ -e "$dotfile" ]; then
                filename=$(basename "$dotfile")
                create_symlink "$dotfile" "$HOME/$filename"
            fi
        done
    fi

    # Setup local config files from templates
    log_info "Setting up local config files from templates..."
    if [ -d "$SCRIPT_DIR/zsh-templates" ]; then
        setup_local_config "$SCRIPT_DIR/zsh-templates/.zshenv.local.template" "$HOME/.zshenv.local"
        setup_local_config "$SCRIPT_DIR/zsh-templates/.zprofile.local.template" "$HOME/.zprofile.local"
        setup_local_config "$SCRIPT_DIR/zsh-templates/.zshrc.local.template" "$HOME/.zshrc.local"
    fi

    # Process all items in .config directory
    log_info "Setting up .config directory items..."
    for config_item in "$SCRIPT_DIR"/.config/*; do
        if [ -e "$config_item" ]; then
            item_name=$(basename "$config_item")
            source_path="$SCRIPT_DIR/.config/$item_name"
            target_path="$HOME/.config/$item_name"

            create_symlink "$source_path" "$target_path"
        fi
    done

    log_info "Config setup completed!"
    log_info ""
    log_info "Next steps:"
    log_info "1. Edit ~/.zshenv.local, ~/.zprofile.local, ~/.zshrc.local with your actual values"
    log_info "2. Restart your shell or run: exec zsh"
}

main
