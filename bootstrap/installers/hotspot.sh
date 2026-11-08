#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install Hotspot

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

VERSION="$(pinned HOTSPOT_VERSION)"

case "$(detect_arch)" in
    amd64)
        ASSET_ARCH="x86_64"
        ;;
    *)
        echo "Hotspot AppImage does not support this architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

command -v python3 >/dev/null || {
    echo "python3 is required." >&2
    exit 1
}

echo "Installing Hotspot v${VERSION}..."

mkdir -p "$BIN_DIR"
make_tmp_dir

release_json="$TMP_DIR/release.json"
appimage="$TMP_DIR/hotspot.AppImage"

fetch \
    "https://api.github.com/repos/KDAB/hotspot/releases/tags/v${VERSION}" \
    "$release_json"

asset_url="$(
    python3 - "$release_json" "$ASSET_ARCH" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    release = json.load(f)

arch = sys.argv[2]

for asset in release.get("assets", []):
    name = asset["name"]
    if name.endswith(".AppImage") and arch in name:
        print(asset["browser_download_url"])
        break
else:
    sys.exit("No matching AppImage found in GitHub release.")
PY
)" || exit 1

fetch "$asset_url" "$appimage"

chmod +x "$appimage"

install_bin "$appimage" hotspot

echo
echo "Hotspot installed:"
"$BIN_DIR/hotspot" --version

echo
echo "Open perf data with:"
echo "  hotspot perf.data"
echo
