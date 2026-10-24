#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install chafa

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned CHAFA_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET="x86_64-linux-gnu"
        ;;
    arm64)
        echo "Chafa does not provide a prebuilt ARM64 archive." >&2
        echo "Consider building it from source." >&2
        exit 1
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo "Installing chafa v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

archive="$TMP_DIR/chafa.tar.gz"

fetch \
    "https://hpjansson.org/chafa/releases/static/chafa-${VERSION}-1-${ASSET}.tar.gz" \
    "$archive"

tar -xzf "$archive" -C "$TMP_DIR"

chafa_bin="$(find "$TMP_DIR" -type f -name chafa -perm /111 -print -quit)"

if [[ -z "$chafa_bin" ]]; then
    echo "Could not find the chafa executable in the archive." >&2
    exit 1
fi

install_bin "$chafa_bin" chafa

echo
echo "chafa installed:"
"$BIN_DIR/chafa" --version

