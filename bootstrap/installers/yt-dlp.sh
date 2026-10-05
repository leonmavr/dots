#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install yt-dlp

set -euo pipefail

VERSION="2026.08.19"
BIN_DIR="$HOME/.local/bin"
BINARY="$BIN_DIR/yt-dlp"

case "$(uname -m)" in
    x86_64)
        ASSET="yt-dlp"
        ;;
    aarch64|arm64)
        ASSET="yt-dlp"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing yt-dlp v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

tmp_binary="$tmp_dir/yt-dlp"

curl -fsSL \
    "https://github.com/yt-dlp/yt-dlp/releases/download/${VERSION}/${ASSET}" \
    -o "$tmp_binary"

# Make sure we actually received an executable.
chmod 755 "$tmp_binary"

# Verify the downloaded binary before installing it.
if ! "$tmp_binary" --version >/dev/null 2>&1; then
    echo "Downloaded yt-dlp binary failed verification." >&2
    exit 1
fi

# Install atomically.
install -m 755 "$tmp_binary" "$BINARY"

echo
echo "yt-dlp installed:"
"$BINARY" --version

echo
echo "Executable:"
echo "  $BINARY"

echo
echo "Make sure ~/.local/bin is in your PATH:"
echo '  export PATH="$HOME/.local/bin:$PATH"'

