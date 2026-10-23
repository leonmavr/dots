#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned FD_VERSION)"

case "$(detect_arch)" in
    amd64)
        ARCH="x86_64"
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
make_tmp_dir

echo "Downloading:"
echo "  $URL"

fetch "$URL" "$TMP_DIR/fd.tar.gz"

tar -xzf "$TMP_DIR/fd.tar.gz" -C "$TMP_DIR"

install_bin "$TMP_DIR/$TARGET/fd" fd

echo
echo "fd installed:"
"$BIN_DIR/fd" --version

echo
echo "Binary:"
echo "  $BIN_DIR/fd"

echo
echo "No shell configuration was created or modified."

