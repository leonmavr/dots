#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install git-delta

set -euo pipefail

VERSION="0.19.2"
BIN_DIR="$HOME/.local/bin"

case "$(uname -m)" in
    x86_64)
        ASSET="delta-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"
        ;;
    aarch64)
        ASSET="delta-${VERSION}-aarch64-unknown-linux-gnu.tar.gz"
        ;;
    arm64)
        ASSET="delta-${VERSION}-aarch64-unknown-linux-gnu.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing git-delta v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/delta.tar.gz"

curl -fsSL \
    "https://github.com/dandavison/delta/releases/download/${VERSION}/${ASSET}" \
    -o "$archive"

tar -xzf "$archive" -C "$tmp_dir"

install -m 755 \
    "$tmp_dir/delta-${VERSION}-"*"/delta" \
    "$BIN_DIR/delta"

echo
echo "git-delta installed:"
"$BIN_DIR/delta" --version

echo
echo 'Make sure ~/.local/bin is in your PATH:'
echo '  export PATH="$HOME/.local/bin:$PATH"'

echo
echo "To configure Git to use delta:"
echo '  git config --global core.pager delta'
echo '  git config --global interactive.diffFilter "delta --color-only"'

