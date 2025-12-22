#!/bin/bash
# 両スクリプトの構文チェックとクイックテスト

set -e

# プロジェクトルートに移動
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

echo "========================================="
echo "  Syntax Check for Both Scripts"
echo "========================================="
echo ""

# 構文チェック
echo "🧪 Testing setup-init.sh..."
if bash -n setup-init.sh; then
    echo "✅ setup-init.sh: Syntax OK"
else
    echo "❌ setup-init.sh: Syntax Error"
    exit 1
fi

echo ""
echo "🧪 Testing setup-config.sh..."
if bash -n setup-config.sh; then
    echo "✅ setup-config.sh: Syntax OK"
else
    echo "❌ setup-config.sh: Syntax Error"
    exit 1
fi

echo ""
echo "========================================="
echo "  All Syntax Checks Passed!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  • Quick test:  ./tests/test-docker.sh"
echo "  • Full test:   ./tests/test-full.sh"
echo ""
