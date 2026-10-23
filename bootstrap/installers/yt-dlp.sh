#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install yt-dlp
# Ensure Deno is installed and up to date (minimum version: > 2.6.0)

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned YTDLP_VERSION)"
BINARY="$BIN_DIR/yt-dlp"
DENO_BIN="$HOME/.deno/bin/deno"

# Prefer the Deno installation managed by the official installer.
export PATH="$HOME/.deno/bin:$PATH"

### Ensure Deno is installed and sufficiently recent

# Returns success if version $1 is <= version $2.
version_le() {
    [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" == "$1" ]]
}

install_deno() {
    echo "Installing/updating Deno..."
    make_tmp_dir
    fetch https://deno.land/install.sh "$TMP_DIR/deno-install.sh"
    sh "$TMP_DIR/deno-install.sh"
    # Ensure the installed executable is available.
    export PATH="$HOME/.deno/bin:$PATH"
    if [[ ! -x "$DENO_BIN" ]]; then
        echo "Deno installation failed: executable not found at $DENO_BIN" >&2
        exit 1
    fi
}

if ! command -v deno >/dev/null 2>&1; then
    echo "Deno is not installed."
    install_deno
else
    DENO_VERSION="$(deno --version | sed -n '1s/^deno \([^ ]*\).*/\1/p')"

    if [[ -z "$DENO_VERSION" ]]; then
        echo "Could not determine the installed Deno version." >&2
        exit 1
    fi

    echo "Detected Deno v${DENO_VERSION}"

    if version_le "$DENO_VERSION" "2.6.0"; then
        echo "Deno v${DENO_VERSION} is too old (requires > 2.6.0)."
        install_deno
    else
        echo "Deno version is sufficient."
    fi
fi

echo
echo "Deno installed:"
deno --version

### Install yt-dlp
ASSET="yt-dlp"

echo
echo "Installing yt-dlp v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

tmp_binary="$TMP_DIR/yt-dlp"

fetch \
    "https://github.com/yt-dlp/yt-dlp/releases/download/${VERSION}/${ASSET}" \
    "$tmp_binary"

# Make sure we actually received an executable
chmod 755 "$tmp_binary"

# Verify the downloaded binary before installing it
if ! "$tmp_binary" --version >/dev/null 2>&1; then
    echo "Downloaded yt-dlp binary failed verification." >&2
    exit 1
fi

# Install atomically
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
