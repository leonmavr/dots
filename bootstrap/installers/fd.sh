#!/usr/bin/env bash

set -euo pipefail

VERSION="10.5.0"
BIN_DIR="$HOME/.local/bin"

case "$(uname -m)" in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64)
        ARCH="aarch64"
        ;;
    arm64)
        ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

TARGET="fd-v${VERSION}-${ARCH}-unknown-linux-gnu"
URL="https://github.com/sharkdp/fd/releases/download/v${VERSION}/${TARGET}.tar.gz"

echo "Installing fd v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="$tmp_dir/fd.tar.gz"

echo "Downloading:"
echo "  $URL"

curl -fsSL "$URL" -o "$archive"

tar -xzf "$archive" -C "$tmp_dir"

install -m 755 "$tmp_dir/$TARGET/fd" "$BIN_DIR/fd"

echo
echo "fd installed:"
"$BIN_DIR/fd" --version

echo
echo "Binary:"
echo "  $BIN_DIR/fd"

echo
echo "No shell configuration was created or modified."

