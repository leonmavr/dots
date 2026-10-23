#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned ZOXIDE_VERSION)"

case "$(detect_arch)" in
    amd64)
        TARGET="x86_64-unknown-linux-musl"
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
make_tmp_dir

echo "Downloading:"
echo "  $URL"

fetch "$URL" "$TMP_DIR/$ARCHIVE"

tar -xzf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR"

install_bin "$TMP_DIR/zoxide" zoxide

echo
echo "zoxide installed:"
"$BIN_DIR/zoxide" --version

echo
echo "Binary:"
echo "  $BIN_DIR/zoxide"

echo
echo "Bash integration is managed by post_install.sh:"
echo '  eval "$(zoxide init bash)"'

