#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install dunst, dunstctl and dunstify
# Ubuntu 26 / Wayland / amd64

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned DUNST_VERSION)"
REPO="leonmavr/dots"
RELEASE="dunst-v${VERSION}"
ASSET="dunst-${VERSION}-linux-amd64.tar.gz"

echo "Installing dunst v${VERSION}..."

if [[ $(detect_arch || true) != amd64 ]]; then
    echo "Unsupported architecture: $(uname -m)" >&2
    echo "This dunst release currently provides an amd64 build." >&2
    exit 1
fi

mkdir -p "$BIN_DIR"
make_tmp_dir

archive="$TMP_DIR/$ASSET"

echo "Downloading ${ASSET}..."

fetch \
    "https://github.com/${REPO}/releases/download/${RELEASE}/${ASSET}" \
    "$archive"

echo "Extracting..."

tar -xzf "$archive" -C "$TMP_DIR"

# Find the extracted directory.
dunst_dir="$TMP_DIR/dunst-${VERSION}-linux-amd64"

if [[ ! -f "$dunst_dir/dunst" ||
      ! -f "$dunst_dir/dunstctl" ||
      ! -f "$dunst_dir/dunstify" ]]; then
    echo "Error: expected dunst binaries were not found in the archive." >&2
    exit 1
fi

install_bin "$dunst_dir/dunst" dunst
install_bin "$dunst_dir/dunstctl" dunstctl
install_bin "$dunst_dir/dunstify" dunstify

echo
echo "Dunst installed:"
"$BIN_DIR/dunst" --version

echo
echo "Installed:"
echo "  $BIN_DIR/dunst"
echo "  $BIN_DIR/dunstctl"
echo "  $BIN_DIR/dunstify"

echo
echo "PATH is managed by post_install.sh."
