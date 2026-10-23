#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install jq

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned JQ_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET="jq-linux-amd64"
        ;;
    arm64)
        ASSET="jq-linux-arm64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing jq v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

binary="$TMP_DIR/jq"

fetch \
    "https://github.com/jqlang/jq/releases/download/jq-${VERSION}/${ASSET}" \
    "$binary"

install_bin "$binary" jq

echo
echo "jq installed:"
"$BIN_DIR/jq" --version

echo
echo "Make sure ~/.local/bin is in your PATH:"
echo '  export PATH="$HOME/.local/bin:$PATH"'

