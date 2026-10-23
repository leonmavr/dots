#!/usr/bin/env bash

# Install a forked build of sxiv - a minimal image viewer

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned SXIV_VERSION)"
require_arch amd64
URL="https://github.com/leonmavr/coolersxiv/releases/download/${VERSION}/coolersxiv-${VERSION}-linux-x86_64.tar.gz"

make_tmp_dir
ARCHIVE="$TMP_DIR/coolersxiv.tar.gz"

echo "Downloading sxiv ${VERSION}..."
fetch "$URL" "$ARCHIVE"

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
install_bin "$SXIV" sxiv

# Install its helper scripts
SXIV_SCRIPT_DIR="$HOME/.config/sxiv/exec"
mkdir -p "$SXIV_SCRIPT_DIR"
if \
    fetch https://raw.githubusercontent.com/leonmavr/coolersxiv/refs/heads/master/exec/image-info "$SXIV_SCRIPT_DIR/image-info" &&
    fetch https://raw.githubusercontent.com/leonmavr/coolersxiv/refs/heads/master/exec/key-handler "$SXIV_SCRIPT_DIR/key-handler" &&
    fetch https://raw.githubusercontent.com/leonmavr/coolersxiv/refs/heads/master/exec/url-handler "$SXIV_SCRIPT_DIR/url-handler"
then
    chmod +x \
        "$SXIV_SCRIPT_DIR/image-info" \
        "$SXIV_SCRIPT_DIR/key-handler" \
        "$SXIV_SCRIPT_DIR/url-handler"
    echo "sxiv helper scripts were installed."
else
    echo "sxiv helper scripts failed to be installed." >&2
fi

echo
echo "sxiv installed successfully:"
echo "  $BIN_DIR/sxiv"
echo
"$BIN_DIR/sxiv" --version 2>/dev/null || true

echo
echo "PATH is managed by post_install.sh."
