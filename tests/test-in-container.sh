#!/bin/bash
# setup-init.sh と setup-config.sh の両方をテストするスクリプト

set -e

# プロジェクトルートに移動
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "========================================="
echo "  Full Integration Test"
echo "  (setup-init.sh + setup-config.sh)"
echo "========================================="
echo ""

# Dockerイメージが存在するか確認
if ! docker images | grep -q "dotfiles-test"; then
    echo "📦 Building Docker test image..."
    docker build -t dotfiles-test:latest -f tests/Dockerfile.test .
    echo ""
fi

echo "🚀 Starting full test environment..."
echo ""
echo "This container includes:"
echo "  • setup-init.sh - System setup script"
echo "  • setup-config.sh - Dotfiles configuration script"
echo "  • All dotfiles (home/, .config/, zsh-templates/)"
echo ""
echo "========================================="
echo ""

# プロジェクト全体をマウントしてコンテナを起動
docker run --rm -it \
    -v "$(pwd):/home/testuser/dotfiles:ro" \
    dotfiles-test:latest \
    /bin/bash -c "
        # dotfiles ディレクトリを読み書き可能な場所にコピー
        cp -r /home/testuser/dotfiles /home/testuser/dotfiles-work
        cd /home/testuser/dotfiles-work

        # スクリプトに実行権限を付与
        chmod +x setup-init.sh setup-config.sh

        echo '========================================='
        echo '  Test Environment Ready!'
        echo '========================================='
        echo ''
        echo '📁 Working directory: /home/testuser/dotfiles-work'
        echo ''
        echo '🔧 Available scripts:'
        echo '  1. ./setup-init.sh   - Install development tools'
        echo '  2. ./setup-config.sh - Setup dotfiles symlinks'
        echo ''
        echo '📝 Recommended test flow:'
        echo '  Step 1: ./setup-init.sh'
        echo '          (Select tools to install)'
        echo ''
        echo '  Step 2: ./setup-config.sh'
        echo '          (Create symlinks for dotfiles)'
        echo ''
        echo '  Step 3: Verify the setup:'
        echo '          ls -la ~ | grep \"^l\"  # Check symlinks'
        echo '          cat ~/.zshrc           # Check zsh config'
        echo ''
        echo '========================================='
        echo ''

        # シェルを起動
        cd /home/testuser/dotfiles-work
        exec /bin/bash
    "

echo ""
echo "========================================="
echo "  Test session ended"
echo "========================================="
