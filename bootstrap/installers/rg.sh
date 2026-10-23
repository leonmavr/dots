#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned RG_VERSION)"

case "$(detect_arch)" in
    amd64)
        TARGET="x86_64-unknown-linux-musl"
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
make_tmp_dir

echo "Downloading:"
echo "  $URL"

fetch "$URL" "$TMP_DIR/$ARCHIVE"

tar -xzf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR"

install_bin \
    "$TMP_DIR/ripgrep-${VERSION}-${TARGET}/rg" \
    rg

echo
echo "ripgrep installed:"
"$BIN_DIR/rg" --version

echo
echo "Binary:"
echo "  $BIN_DIR/rg"

echo
echo "No shell configuration was created or modified."

