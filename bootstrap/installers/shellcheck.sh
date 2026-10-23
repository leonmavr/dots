#!/bin/bash

# Purpose:
# Locally (at ~/.local/bin) install ShellCheck

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned SHELLCHECK_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET="shellcheck-v${VERSION}.linux.x86_64.tar.xz"
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
make_tmp_dir

archive="$TMP_DIR/$ASSET"

fetch \
    "https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/${ASSET}" \
    "$archive"

tar -xJf "$archive" -C "$TMP_DIR"

install_bin "$TMP_DIR/$ARCH_DIR/shellcheck" shellcheck

echo
echo "ShellCheck installed:"
"$BIN_DIR/shellcheck" --version

echo
echo "Location:"
echo "  $BIN_DIR/shellcheck"

