#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install yt-dlp
# Ensure Deno is installed and up to date (minimum version: > 2.6.0)

set -euo pipefail

VERSION="2026.08.19"
BIN_DIR="$HOME/.local/bin"
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
    curl -fsSL https://deno.land/install.sh | sh
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
case "$(uname -m)" in
    x86_64)
        ASSET="yt-dlp"
        ;;
    aarch64|arm64)
        ASSET="yt-dlp"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

echo
echo "Installing yt-dlp v${VERSION}..."

mkdir -p "$BIN_DIR"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

tmp_binary="$tmp_dir/yt-dlp"

curl -fsSL \
    "https://github.com/yt-dlp/yt-dlp/releases/download/${VERSION}/${ASSET}" \
    -o "$tmp_binary"

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
