#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install eza

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned EZA_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET="eza_x86_64-unknown-linux-gnu.tar.gz"
        ;;
    arm64)
        ASSET="eza_aarch64-unknown-linux-gnu.tar.gz"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing eza v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

archive="$TMP_DIR/eza.tar.gz"

fetch \
    "https://github.com/eza-community/eza/releases/download/v${VERSION}/${ASSET}" \
    "$archive"

tar -xzf "$archive" -C "$TMP_DIR"

install_bin "$TMP_DIR/eza" eza

echo
echo "eza installed:"
"$BIN_DIR/eza" --version

echo
echo 'Make sure ~/.local/bin is in your PATH:'
echo '  export PATH="$HOME/.local/bin:$PATH"'

