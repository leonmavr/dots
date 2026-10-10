#!/bin/bash

###
# Purpose
# Locally install watchexec at ~/.local/bin.
#
# Watchexec reruns commands when watched files change.
###

set -euo pipefail

VERSION="2.8.0"
BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

case "$(uname -m)" in
    x86_64)
        ASSET="x86_64-unknown-linux-gnu"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing watchexec v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

filename="watchexec-${VERSION}-${ASSET}.tar.xz"
archive="$tmp_dir/$filename"
url="https://github.com/watchexec/watchexec/releases/download/v${VERSION}/${filename}"

echo "Downloading: $url"
curl -fsSL "$url" -o "$archive"

tar -xJf "$archive" -C "$tmp_dir"

watchexec_bin="$(find "$tmp_dir" -type f -name watchexec -print -quit)"

if [[ -z "$watchexec_bin" ]]; then
    echo "Error: watchexec binary not found in archive." >&2
    exit 1
fi

install -m 755 "$watchexec_bin" "$BIN_DIR/watchexec"

# Add ~/.local/bin to PATH.
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

if [[ ! -f "$BASHRC" ]]; then
    touch "$BASHRC"
fi

if ! grep -Fqx "$PATH_LINE" "$BASHRC"; then
    {
        echo
        echo "# Local binaries"
        echo "$PATH_LINE"
    } >> "$BASHRC"

    echo "Added ~/.local/bin to PATH in $BASHRC"
fi

echo
echo "Watchexec installed successfully:"
"$BIN_DIR/watchexec" --version

echo
echo "Installation complete."
echo "Activate PATH in your current shell with:"
echo "  source ~/.bashrc"
