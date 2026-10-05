#!/bin/bash

### Purpose
# Install local fonts into ~/.local/share/fonts

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/../../.local/share/fonts"
FONT_DIR="$HOME/.local/share/fonts"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Font source directory not found:"
    echo "  $SOURCE_DIR" >&2
    exit 1
fi

echo "Installing fonts..."

mkdir -p "$FONT_DIR"

# Copy each font directory while preserving its structure.
for font_dir in "$SOURCE_DIR"/*/; do
    [[ -d "$font_dir" ]] || continue

    font_name="$(basename "$font_dir")"

    echo "  Installing $font_name..."
    mkdir -p "$FONT_DIR/$font_name"

    cp -a "$font_dir"/. "$FONT_DIR/$font_name"/
done

# Refresh the font cache if fc-cache is available.
if command -v fc-cache >/dev/null 2>&1; then
    echo
    echo "Refreshing font cache..."
    fc-cache -f "$FONT_DIR"
else
    echo
    echo "Warning: fc-cache not found; font cache was not refreshed."
    echo "Install fontconfig if necessary."
fi

echo
echo "Fonts installed to:"
echo "  $FONT_DIR"
