#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install calcure

set -euo pipefail

VERSION="c529fe2"
BIN_DIR="$HOME/.local/bin"
DOWNLOAD_URL="https://github.com/leonmavr/calcure/releases/download/${VERSION}/calcure-linux-x86_64.tar.gz"

echo "Installing calcure (${VERSION})..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/calcure.tar.gz"

curl -fsSL "$DOWNLOAD_URL" -o "$archive"

tar -xzf "$archive" -C "$tmp_dir"

if [[ ! -f "$tmp_dir/calcure/calcure" ]]; then
    echo "ERROR: calcure binary not found in the archive" >&2
    exit 1
fi

install -m 755 "$tmp_dir/calcure/calcure" "$BIN_DIR/calcure"

echo
echo "calcure installed:"
"$BIN_DIR/calcure" --version 2>/dev/null || echo "Installed successfully."

echo
echo "Binary location: $BIN_DIR/calcure"
