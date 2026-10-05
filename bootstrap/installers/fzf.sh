#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install fzf

set -euo pipefail

VERSION="0.74.4"
BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

case "$(uname -m)" in
    x86_64)
        ASSET="linux_amd64"
        ;;
    aarch64)
        ASSET="linux_arm64"
        ;;
    arm64)
        ASSET="linux_arm64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing fzf v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/fzf.tar.gz"

curl -fsSL \
    "https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-${ASSET}.tar.gz" \
    -o "$archive"

tar -xzf "$archive" -C "$tmp_dir"

install -m 755 "$tmp_dir/fzf" "$BIN_DIR/fzf"

# Add fzf to PATH and enable Bash integration.
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
BASH_LINE='eval "$(fzf --bash)"'

if [[ ! -f "$BASHRC" ]]; then
    touch "$BASHRC"
fi

if ! grep -Fqx "$PATH_LINE" "$BASHRC"; then
    {
        echo
        echo "# fzf"
        echo "$PATH_LINE"
    } >> "$BASHRC"

    echo "Added fzf to PATH in $BASHRC"
fi

if ! grep -Fqx "$BASH_LINE" "$BASHRC"; then
    echo "$BASH_LINE" >> "$BASHRC"
    echo "Added fzf Bash integration to $BASHRC"
fi

echo
echo "fzf installed:"
"$BIN_DIR/fzf" --version

echo
echo "Run this to activate it in the current shell:"
echo "  source ~/.bashrc"
echo
echo "Ctrl-R: history search"
echo "Ctrl-T: file search"
echo "Alt-C: directory search"


