#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install fzf

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned FZF_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET="linux_amd64"
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
make_tmp_dir

archive="$TMP_DIR/fzf.tar.gz"

fetch \
    "https://github.com/junegunn/fzf/releases/download/v${VERSION}/fzf-${VERSION}-${ASSET}.tar.gz" \
    "$archive"

tar -xzf "$archive" -C "$TMP_DIR"

install_bin "$TMP_DIR/fzf" fzf

echo
echo "fzf installed:"
"$BIN_DIR/fzf" --version

echo
echo "PATH and Bash integration are managed by post_install.sh."
echo "Run the post-install step once to enable them."
echo
echo "Ctrl-R: history search"
echo "Ctrl-T: file search"
echo "Alt-C: directory search"


