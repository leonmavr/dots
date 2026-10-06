#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install eza

set -euo pipefail

VERSION="0.23.4"
BIN_DIR="$HOME/.local/bin"

case "$(uname -m)" in
    x86_64)
        ASSET="eza_x86_64-unknown-linux-gnu.tar.gz"
        ;;
    aarch64)
        ASSET="eza_aarch64-unknown-linux-gnu.tar.gz"
        ;;
    arm64)
        ASSET="eza_aarch64-unknown-linux-gnu.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing eza v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/eza.tar.gz"

curl -fsSL \
    "https://github.com/eza-community/eza/releases/download/v${VERSION}/${ASSET}" \
    -o "$archive"

tar -xzf "$archive" -C "$tmp_dir"

install -m 755 "$tmp_dir/eza" "$BIN_DIR/eza"

echo
echo "eza installed:"
"$BIN_DIR/eza" --version

echo
echo 'Make sure ~/.local/bin is in your PATH:'
echo '  export PATH="$HOME/.local/bin:$PATH"'

