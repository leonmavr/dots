#!/usr/bin/env bash

set -euo pipefail

REPO="https://github.com/ranger/ranger.git"
INSTALL_DIR="$HOME/.local/share/ranger"
BIN_DIR="$HOME/.local/bin"
PYTHON="${PYTHON:-python3}"

echo "Installing latest ranger from GitHub..."

# Check dependencies.
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required." >&2
    exit 1
fi

if ! command -v "$PYTHON" >/dev/null 2>&1; then
    echo "Error: $PYTHON not found." >&2
    exit 1
fi

mkdir -p "$BIN_DIR"

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

echo
echo "ranger installed from GitHub:"
git -C "$INSTALL_DIR" log -1 --format='%h %ad %s' --date=short

echo
echo "Executable:"
echo "  $BIN_DIR/ranger"

echo "Source:"
echo "  $INSTALL_DIR"

echo
echo "No ranger configuration was created or modified."
