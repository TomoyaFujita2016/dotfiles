#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo "${RED}[ERROR]${NC} $1"
}

# 現在のスクリプトの場所を取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# バックアップ用のタイムスタンプ
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# シンボリックリンクを作成する関数
create_symlink() {
    local source="$1"
    local target="$2"
    
    # ターゲットディレクトリが存在しない場合は作成
    target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        log_info "Created directory: $target_dir"
    fi

    # ターゲットが既に存在する場合の処理
    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            # 既存のシンボリックリンクが同じ場所を指している場合はスキップ
            current_link=$(readlink "$target")
            if [ "$current_link" == "$source" ]; then
                log_info "Symlink already exists and points to the correct location: $target -> $source"
                return
            fi
        fi
        
        # バックアップを作成
        backup_path="${target}.org_${TIMESTAMP}"
        mv "$target" "$backup_path"
        log_warn "Existing file backed up: $backup_path"
    fi

    # シンボリックリンクを作成
    ln -s "$source" "$target"
    log_info "Created symlink: $target -> $source"
}

main() {
    log_info "Starting config setup..."

    # .config ディレクトリ内の各ディレクトリに対して処理
    for config_dir in "$SCRIPT_DIR"/.config/*; do
        if [ -d "$config_dir" ]; then
            dir_name=$(basename "$config_dir")
            source_path="$SCRIPT_DIR/.config/$dir_name"
            target_path="$HOME/.config/$dir_name"
            
            create_symlink "$source_path" "$target_path"
        fi
    done

    log_info "Config setup completed!"
}

main
