#!/bin/bash

### Purpose
# Locally (at ~/.local) install Neovim

set -euo pipefail

VERSION="0.12.5"
INSTALL_DIR="$HOME/.local"
BIN_DIR="$INSTALL_DIR/bin"

case "$(uname -m)" in
    x86_64)
        ASSET="nvim-linux-x86_64"
        ;;
    aarch64)
        ASSET="nvim-linux-arm64"
        ;;
    arm64)
        ASSET="nvim-linux-arm64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing Neovim v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/nvim.tar.gz"

curl -fsSL \
    "https://github.com/neovim/neovim/releases/download/v${VERSION}/${ASSET}.tar.gz" \
    -o "$archive"

tar -xzf "$archive" -C "$tmp_dir"

# Remove an existing installation.
rm -rf "$INSTALL_DIR/nvim"

# Install Neovim.
mv "$tmp_dir/$ASSET" "$INSTALL_DIR/nvim"

# Make nvim available through ~/.local/bin.
ln -sfn "$INSTALL_DIR/nvim/bin/nvim" "$BIN_DIR/nvim"

echo
echo "Neovim installed:"
"$BIN_DIR/nvim" --version | head -n 1

echo
echo "Run this to activate it in the current shell:"
echo "  source ~/.bashrc"
echo
echo "Neovim executable:"
echo "  $BIN_DIR/nvim"

