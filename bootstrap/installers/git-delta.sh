#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install git-delta

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned DELTA_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET="delta-${VERSION}-x86_64-unknown-linux-gnu.tar.gz"
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
make_tmp_dir

archive="$TMP_DIR/delta.tar.gz"

fetch \
    "https://github.com/dandavison/delta/releases/download/${VERSION}/${ASSET}" \
    "$archive"

tar -xzf "$archive" -C "$TMP_DIR"

install_bin \
    "$TMP_DIR/delta-${VERSION}-"*"/delta" \
    delta

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

