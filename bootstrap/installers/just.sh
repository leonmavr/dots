#!/bin/bash

###
# Purpose
# Locally install just at ~/.local/bin.
#
# just is a command runner that lets you define project commands
# in a file named justfile.
###

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned JUST_VERSION)"

require_arch amd64 arm64

echo "Installing just v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

installer="$TMP_DIR/install.sh"

fetch \
    "https://just.systems/install.sh" \
    "$installer"

bash "$installer" --tag "$VERSION" --to "$BIN_DIR"

echo
echo "just installed:"
"$BIN_DIR/just" --version

echo
echo "Installation complete."
echo "PATH is managed by post_install.sh."
