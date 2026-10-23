#!/bin/bash

### Purpose
# Locally (at ~/.local) install Neovim

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned NVIM_VERSION)"
INSTALL_DIR="$HOME/.local"

case "$(detect_arch)" in
    amd64)
        ASSET="nvim-linux-x86_64"
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
make_tmp_dir

archive="$TMP_DIR/nvim.tar.gz"

fetch \
    "https://github.com/neovim/neovim/releases/download/v${VERSION}/${ASSET}.tar.gz" \
    "$archive"

tar -xzf "$archive" -C "$TMP_DIR"

# Remove an existing installation.
rm -rf "$INSTALL_DIR/nvim"

# Install Neovim.
mv "$TMP_DIR/$ASSET" "$INSTALL_DIR/nvim"

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

