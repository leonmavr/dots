#!/usr/bin/env bash

set -euo pipefail

VERSION="0.10.0"
BIN_DIR="$HOME/.local/bin"
BASHRC="$HOME/.bashrc"

case "$(uname -m)" in
    x86_64)
        TARGET="x86_64-unknown-linux-musl"
        ;;
    aarch64)
        TARGET="aarch64-unknown-linux-musl"
        ;;
    arm64)
        TARGET="aarch64-unknown-linux-musl"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

ARCHIVE="zoxide-${VERSION}-${TARGET}.tar.gz"
URL="https://github.com/ajeetdsouza/zoxide/releases/download/v${VERSION}/${ARCHIVE}"

echo "Installing zoxide v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "Downloading:"
echo "  $URL"

curl -fsSL "$URL" -o "$tmp_dir/$ARCHIVE"

tar -xzf "$tmp_dir/$ARCHIVE" -C "$tmp_dir"

install -m 755 \
    "$tmp_dir/zoxide" \
    "$BIN_DIR/zoxide"

# Add Bash integration if it isn't already present.
BASH_LINE='eval "$(zoxide init bash)"'

if [[ ! -f "$BASHRC" ]]; then
    touch "$BASHRC"
fi

if grep -Fqx "$BASH_LINE" "$BASHRC"; then
    echo "zoxide Bash integration already present in $BASHRC"
else
    {
        echo
        echo "# zoxide"
        echo "$BASH_LINE"
    } >> "$BASHRC"

    echo "Added zoxide Bash integration to $BASHRC"
fi

echo
echo "zoxide installed:"
"$BIN_DIR/zoxide" --version

echo
echo "Binary:"
echo "  $BIN_DIR/zoxide"

echo
echo "Bash integration:"
echo "  $BASH_LINE"

echo
echo "Run this to activate it in the current shell:"
echo "  source ~/.bashrc"

