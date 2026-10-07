#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install dunst, dunstctl and dunstify
# Ubuntu 26 / Wayland / amd64

set -euo pipefail

VERSION="1.13.2"
BIN_DIR="$HOME/.local/bin"
REPO="leonmavr/dots"
RELEASE="dunst-v${VERSION}"
ASSET="dunst-${VERSION}-linux-amd64.tar.gz"

echo "Installing dunst v${VERSION}..."

case "$(uname -m)" in
    x86_64)
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        echo "This dunst release currently provides an amd64 build." >&2
        exit 1
        ;;
esac

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/$ASSET"

echo "Downloading ${ASSET}..."

curl -fsSL \
    "https://github.com/${REPO}/releases/download/${RELEASE}/${ASSET}" \
    -o "$archive"

echo "Extracting..."

tar -xzf "$archive" -C "$tmp_dir"

# Find the extracted directory.
dunst_dir="$tmp_dir/dunst-${VERSION}-linux-amd64"

if [[ ! -f "$dunst_dir/dunst" ||
      ! -f "$dunst_dir/dunstctl" ||
      ! -f "$dunst_dir/dunstify" ]]; then
    echo "Error: expected dunst binaries were not found in the archive." >&2
    exit 1
fi

install -m 755 "$dunst_dir/dunst"    "$BIN_DIR/dunst"
install -m 755 "$dunst_dir/dunstctl" "$BIN_DIR/dunstctl"
install -m 755 "$dunst_dir/dunstify" "$BIN_DIR/dunstify"

# Add ~/.local/bin to PATH.
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
BASHRC="$HOME/.bashrc"

if [[ ! -f "$BASHRC" ]]; then
    touch "$BASHRC"
fi

if ! grep -Fqx "$PATH_LINE" "$BASHRC"; then
    {
        echo
        echo "# dunst"
        echo "$PATH_LINE"
    } >> "$BASHRC"

    echo "Added dunst to PATH in $BASHRC"
fi

echo
echo "Dunst installed:"
"$BIN_DIR/dunst" --version

echo
echo "Installed:"
echo "  $BIN_DIR/dunst"
echo "  $BIN_DIR/dunstctl"
echo "  $BIN_DIR/dunstify"

echo
echo "Run this to activate it in the current shell:"
echo "  source ~/.bashrc"
