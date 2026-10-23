#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install calcure

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned CALCURE_VERSION)"
require_arch amd64
DOWNLOAD_URL="https://github.com/leonmavr/calcure/releases/download/${VERSION}/calcure-linux-x86_64.tar.gz"

echo "Installing calcure (${VERSION})..."

mkdir -p "$BIN_DIR"
make_tmp_dir

archive="$TMP_DIR/calcure.tar.gz"

fetch "$DOWNLOAD_URL" "$archive"

tar -xzf "$archive" -C "$TMP_DIR"

if [[ ! -f "$TMP_DIR/calcure/calcure" ]]; then
    echo "ERROR: calcure binary not found in the archive" >&2
    exit 1
fi

install_bin "$TMP_DIR/calcure/calcure" calcure

echo
echo "calcure installed:"
"$BIN_DIR/calcure" --version 2>/dev/null || echo "Installed successfully."

echo
echo "Binary location: $BIN_DIR/calcure"
