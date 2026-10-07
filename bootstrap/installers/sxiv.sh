#!/usr/bin/env bash

# Install a forked build of sxiv - a minimal image viewer

set -e

VERSION="v27"
BIN_DIR="$HOME/.local/bin"
URL="https://github.com/leonmavr/coolersxiv/releases/download/${VERSION}/coolersxiv-v27-linux-x86_64.tar.gz"

TMP_DIR="$(mktemp -d)"
ARCHIVE="$TMP_DIR/coolersxiv.tar.gz"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading sxiv ${VERSION}..."
curl -fL "$URL" -o "$ARCHIVE"

echo "Extracting..."
tar -xzf "$ARCHIVE" -C "$TMP_DIR"

mkdir -p "$BIN_DIR"

# Find the binary regardless of the archive's top-level directory.
SXIV="$(find "$TMP_DIR" -type f -name '*sxiv' -print -quit)"

if [ -z "$SXIV" ]; then
    echo "Error: could not find 'sxiv' in the archive."
    exit 1
fi

echo "Installing to $BIN_DIR..."
install -m 755 "$SXIV" "$BIN_DIR/sxiv"

# Add ~/.local/bin to PATH for Bash if needed.
if ! grep -qsF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$BIN_DIR:$PATH"

echo
echo "sxiv installed successfully:"
echo "  $(command -v sxiv)"
echo
sxiv --version 2>/dev/null || true
