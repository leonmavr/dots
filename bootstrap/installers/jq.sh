#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install jq

set -euo pipefail

VERSION="1.8.1"
BIN_DIR="$HOME/.local/bin"

case "$(uname -m)" in
    x86_64)
        ASSET="jq-linux-amd64"
        ;;
    aarch64)
        ASSET="jq-linux-arm64"
        ;;
    arm64)
        ASSET="jq-linux-arm64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing jq v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

binary="$tmp_dir/jq"

curl -fsSL \
    "https://github.com/jqlang/jq/releases/download/jq-${VERSION}/${ASSET}" \
    -o "$binary"

install -m 755 "$binary" "$BIN_DIR/jq"

echo
echo "jq installed:"
"$BIN_DIR/jq" --version

echo
echo "Make sure ~/.local/bin is in your PATH:"
echo '  export PATH="$HOME/.local/bin:$PATH"'

