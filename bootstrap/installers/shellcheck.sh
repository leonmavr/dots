#!/bin/bash

# Purpose:
# Locally (at ~/.local/bin) install ShellCheck

set -euo pipefail

VERSION="0.11.0"
BIN_DIR="$HOME/.local/bin"

case "$(uname -m)" in
    x86_64)
        ASSET="shellcheck-v${VERSION}.linux.x86_64.tar.xz"
        ARCH_DIR="shellcheck-v${VERSION}"
        ;;
    aarch64)
        ASSET="shellcheck-v${VERSION}.linux.aarch64.tar.xz"
        ARCH_DIR="shellcheck-v${VERSION}"
        ;;
    arm64)
        ASSET="shellcheck-v${VERSION}.linux.aarch64.tar.xz"
        ARCH_DIR="shellcheck-v${VERSION}"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing ShellCheck v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/$ASSET"

curl -fsSL \
    "https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/${ASSET}" \
    -o "$archive"

tar -xJf "$archive" -C "$tmp_dir"

install -m 755 \
    "$tmp_dir/$ARCH_DIR/shellcheck" \
    "$BIN_DIR/shellcheck"

echo
echo "ShellCheck installed:"
"$BIN_DIR/shellcheck" --version

echo
echo "Location:"
echo "  $BIN_DIR/shellcheck"

