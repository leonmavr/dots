#!/bin/bash

###
# Purpose
# Locally install just at ~/.local/bin.
#
# just is a command runner that lets you define project commands
# in a file named justfile.
###

set -euo pipefail

VERSION="1.58.0"
BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

case "$(uname -m)" in
    x86_64|aarch64|arm64)
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing just v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

installer="$tmp_dir/install.sh"

curl -fsSL \
    "https://just.systems/install.sh" \
    -o "$installer"

bash "$installer" --tag "$VERSION" --to "$BIN_DIR"

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
echo "just installed:"
"$BIN_DIR/just" --version

echo
echo "Installation complete."
echo "Activate PATH in your current shell with:"
echo "  source ~/.bashrc"
