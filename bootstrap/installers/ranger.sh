#!/usr/bin/env bash

set -euo pipefail

REPO="https://github.com/ranger/ranger.git"
DEVICONS_REPO="https://github.com/alexanderjeurissen/ranger_devicons.git"

INSTALL_DIR="$HOME/.local/share/ranger"
BIN_DIR="$HOME/.local/bin"

FONT_DIR="$HOME/.local/share/fonts/HackNerdFont"
DEVICONS_DIR="$HOME/.config/ranger/plugins/ranger_devicons"
RANGER_CONFIG_DIR="$HOME/.config/ranger"
RANGER_RC="$RANGER_CONFIG_DIR/rc.conf"

PYTHON="${PYTHON:-python3}"

echo "Installing latest ranger from GitHub..."

# ---------------------------------------------------------------------------
# Check dependencies
# ---------------------------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required." >&2
    exit 1
fi

if ! command -v "$PYTHON" >/dev/null 2>&1; then
    echo "Error: $PYTHON not found." >&2
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required." >&2
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    echo "Error: tar is required." >&2
    exit 1
fi

mkdir -p "$BIN_DIR"

# ---------------------------------------------------------------------------
# Install ranger
# ---------------------------------------------------------------------------

# Remove old executable/symlink before installing.
# This is important because an old symlink to ranger.py could cause
# the wrapper below to overwrite the actual ranger source file.
rm -f "$BIN_DIR/ranger"
rm -f "$BIN_DIR/rifle"

# Re-clone the repository if an existing checkout may have been
# modified by a previous installation.
if [[ -d "$INSTALL_DIR/.git" ]]; then
    echo "Resetting existing ranger checkout..."

    git -C "$INSTALL_DIR" fetch --depth 1 origin master
    git -C "$INSTALL_DIR" reset --hard origin/master
    git -C "$INSTALL_DIR" clean -fd
else
    echo "Cloning ranger..."

    rm -rf "$INSTALL_DIR"
    git clone --depth 1 "$REPO" "$INSTALL_DIR"
fi

# Create a wrapper for ranger.
cat > "$BIN_DIR/ranger" <<EOF
#!/usr/bin/env bash
exec "$PYTHON" "$INSTALL_DIR/ranger.py" "\$@"
EOF

chmod +x "$BIN_DIR/ranger"

# Create a wrapper for rifle.
cat > "$BIN_DIR/rifle" <<EOF
#!/usr/bin/env bash
exec "$PYTHON" "$INSTALL_DIR/ranger/ext/rifle.py" "\$@"
EOF

chmod +x "$BIN_DIR/rifle"

# ---------------------------------------------------------------------------
# Install Hack Nerd Font
# ---------------------------------------------------------------------------

echo
echo "Installing Hack Nerd Font..."

mkdir -p "$FONT_DIR"

tmp_font_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_font_dir"' EXIT

FONT_ARCHIVE="$tmp_font_dir/Hack.tar.xz"

curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz" \
    -o "$FONT_ARCHIVE"

tar -xJf "$FONT_ARCHIVE" -C "$FONT_DIR"

# Refresh the user's font cache.
if command -v fc-cache >/dev/null 2>&1; then
    echo "Refreshing font cache..."
    fc-cache -f "$HOME/.local/share/fonts"
else
    echo "Warning: fc-cache not found; font cache was not refreshed." >&2
fi

# Verify that Fontconfig can see the Nerd Font.
if command -v fc-match >/dev/null 2>&1; then
    if ! fc-match "Hack Nerd Font" >/dev/null 2>&1; then
        echo "Warning: Hack Nerd Font was installed but Fontconfig could not find it." >&2
    fi
fi

# ---------------------------------------------------------------------------
# Install ranger_devicons
# ---------------------------------------------------------------------------

echo
echo "Installing ranger_devicons..."

mkdir -p "$(dirname "$DEVICONS_DIR")"

if [[ -d "$DEVICONS_DIR/.git" ]]; then
    echo "Updating existing ranger_devicons checkout..."

    git -C "$DEVICONS_DIR" fetch --depth 1 origin

    DEFAULT_BRANCH="$(
        git -C "$DEVICONS_DIR" symbolic-ref \
            --short refs/remotes/origin/HEAD |
        sed 's#^origin/##'
    )"

    git -C "$DEVICONS_DIR" reset --hard "origin/$DEFAULT_BRANCH"
    git -C "$DEVICONS_DIR" clean -fd
else
    rm -rf "$DEVICONS_DIR"

    git clone --depth 1 \
        "$DEVICONS_REPO" \
        "$DEVICONS_DIR"
fi

# ---------------------------------------------------------------------------
# Enable devicons in ranger
# ---------------------------------------------------------------------------

mkdir -p "$RANGER_CONFIG_DIR"

if [[ ! -f "$RANGER_RC" ]]; then
    touch "$RANGER_RC"
fi

DEVICONS_CONFIG="default_linemode devicons"

if ! grep -Fqx "$DEVICONS_CONFIG" "$RANGER_RC"; then
    echo "$DEVICONS_CONFIG" >> "$RANGER_RC"
    echo "Enabled devicons in $RANGER_RC"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo
echo "ranger installed from GitHub:"
git -C "$INSTALL_DIR" log -1 --format='%h %ad %s' --date=short

echo
echo "Executable:"
echo "  $BIN_DIR/ranger"

echo
echo "Source:"
echo "  $INSTALL_DIR"

echo
echo "Hack Nerd Font:"
echo "  $FONT_DIR"

echo
echo "ranger_devicons:"
echo "  $DEVICONS_DIR"

echo
echo "ranger configuration:"
echo "  $RANGER_RC"

echo
echo "No other ranger configuration was modified."

echo
echo "Set your terminal font to:"
echo "  Hack Nerd Font"

