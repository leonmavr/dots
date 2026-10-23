#!/bin/bash

###
# Purpose
# Locally install watchexec at ~/.local/bin.
#
# Watchexec reruns commands when watched files change.
###

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned WATCHEXEC_VERSION)"

require_arch amd64
ASSET="x86_64-unknown-linux-gnu"

echo "Installing watchexec v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

filename="watchexec-${VERSION}-${ASSET}.tar.xz"
archive="$TMP_DIR/$filename"
url="https://github.com/watchexec/watchexec/releases/download/v${VERSION}/${filename}"

echo "Downloading: $url"
fetch "$url" "$archive"

tar -xJf "$archive" -C "$TMP_DIR"

watchexec_bin="$(find "$TMP_DIR" -type f -name watchexec -print -quit)"

if [[ -z "$watchexec_bin" ]]; then
    echo "Error: watchexec binary not found in archive." >&2
    exit 1
fi

install_bin "$watchexec_bin" watchexec

echo
echo "Watchexec installed successfully:"
"$BIN_DIR/watchexec" --version

echo
echo "Installation complete."
echo "PATH is managed by post_install.sh."
