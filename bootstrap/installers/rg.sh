#!/usr/bin/env bash

set -euo pipefail

VERSION="15.2.0"
BIN_DIR="$HOME/.local/bin"

case "$(uname -m)" in
    x86_64)
        TARGET="x86_64-unknown-linux-musl"
        ;;
    aarch64)
        TARGET="aarch64-unknown-linux-gnu"
        ;;
    arm64)
        TARGET="aarch64-unknown-linux-gnu"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

ARCHIVE="ripgrep-${VERSION}-${TARGET}.tar.gz"
URL="https://github.com/BurntSushi/ripgrep/releases/download/${VERSION}/${ARCHIVE}"

echo "Installing ripgrep v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "Downloading:"
echo "  $URL"

curl -fsSL "$URL" -o "$tmp_dir/$ARCHIVE"

tar -xzf "$tmp_dir/$ARCHIVE" -C "$tmp_dir"

install -m 755 \
    "$tmp_dir/ripgrep-${VERSION}-${TARGET}/rg" \
    "$BIN_DIR/rg"

echo
echo "ripgrep installed:"
"$BIN_DIR/rg" --version

echo
echo "Binary:"
echo "  $BIN_DIR/rg"

echo
echo "No shell configuration was created or modified."

