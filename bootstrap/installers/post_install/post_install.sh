#!/bin/bash

### Purpose
# Install local Bash configuration and fzf config.
#
# Options:
#   --create-config    Copy repository .config contents into ~/.config

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BASHRC="$HOME/.bashrc"
BASH_DIR="$HOME/.bash"
CONFIG_DIR="$HOME/.config"

FZF_CONFIG_SOURCE="$SCRIPT_DIR/../../../.bash/.fzf.bash"
FZF_CONFIG_DEST="$BASH_DIR/.fzf.bash"

CREATE_CONFIG=false

### Parse arguments

case "${1:-}" in
    "")
        ;;
    --create-config)
        CREATE_CONFIG=true
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Usage: $0 [--create-config]" >&2
        exit 1
        ;;
esac

### bashrc

if [[ ! -f "$BASHRC" ]]; then
    touch "$BASHRC"
fi

mkdir -p "$BASH_DIR"

### Copy fzf configuration

if [[ ! -f "$FZF_CONFIG_SOURCE" ]]; then
    echo "fzf config not found:"
    echo "  $FZF_CONFIG_SOURCE" >&2
    exit 1
fi

install -m 644 "$FZF_CONFIG_SOURCE" "$FZF_CONFIG_DEST"

echo "Installed fzf config:"
echo "  $FZF_CONFIG_DEST"

### git config
GIT_CFG="$SCRIPT_DIR/../../../.gitconfig"
GIT_COMPLETION="$SCRIPT_DIR/../../../.git-completion.bash"
if [ -f $GIT_CFG ]; then
    cp $GIT_CFG ~
    echo "Copied git config"
else
    echo "Git config not found"
fi
[ -f $GIT_COMPLETION ] && cp $GIT_COMPLETION ~

# Prefer git-delta for diff if installed
if [[ -x "$HOME/.local/bin/delta" ]]; then
    git config --global core.pager delta
    echo "Configured Git to use delta as pager"
else
    echo "git-delta not installed; skipping Git delta configuration"
fi


### bashrc configuration

### Copy Bash scripts

# This is where common bash utilities live
SCRIPTS_SOURCE="$SCRIPT_DIR/../../../.bash/scripts"
SCRIPTS_DEST="$BASH_DIR/scripts"

if [[ ! -d "$SCRIPTS_SOURCE" ]]; then
    echo "Bash scripts directory not found:"
    echo "  $SCRIPTS_SOURCE" >&2
    exit 1
fi

mkdir -p "$SCRIPTS_DEST"
cp -a "$SCRIPTS_SOURCE"/. "$SCRIPTS_DEST"/

echo "Installed Bash scripts:"
echo "  $SCRIPTS_SOURCE"
echo "  -> $SCRIPTS_DEST"

if [[ -d "$HOME/.bash/scripts" && ":$PATH:" != *":$HOME/.bash/scripts:"* ]]; then
    echo 'export PATH="$HOME/.bash/scripts:$PATH"' >> "$BASHRC"
    echo "Added: \$HOME/.bash/scripts to PATH"
fi

# Remove old versions of lines managed by this installer.
#
# IMPORTANT:
# Only remove complete configuration lines. Do not touch surrounding
# if/then/fi blocks from the system .bashrc.

sed -i \
    -e '/^[[:space:]]*eval "\$(fzf --bash)"[[:space:]]*$/d' \
    -e '/^[[:space:]]*eval "\$(command fzf --bash)"[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/\.fzf\.bash[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/\.fzf\.bash[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_aliases[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_aliases[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_prompt[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_prompt[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_history_cfg[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_history_cfg[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_shopt[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_shopt[[:space:]]*$/d' \
    -e '/^[[:space:]]*export INPUTRC=.*$/d' \
    -e '/^[[:space:]]*bind -f "\$INPUTRC"[[:space:]]*$/d' \
    -e '/^[[:space:]]*eval "\$(zoxide init bash)"[[:space:]]*$/d' \
    -e '/^[[:space:]]*touch \$INPUTRC[[:space:]]*$/d' \
    "$BASHRC"

# Add managed lines if they are not already present.
#
# We deliberately do NOT modify the system's existing ~/.local/bin
# if/then/fi block. If ~/.local/bin is already in PATH, this line
# is simply unnecessary.

lines=(
    'export PATH="$HOME/.local/bin:$PATH"'
    'eval "$(command fzf --bash)"'
    '[ -f ~/.bash/.fzf.bash ] && source ~/.bash/.fzf.bash'
    '[ -f ~/.bash/bash_aliases ] && source ~/.bash/bash_aliases'
    '[ -f ~/.bash/bash_prompt ] && source ~/.bash/bash_prompt'
    '[ -f ~/.bash/bash_history_cfg ] && source ~/.bash/bash_history_cfg'
    '[ -f ~/.bash/bash_shopt ] && source ~/.bash/bash_shopt'
    'export INPUTRC="$HOME/.bash/inputrc"'
    'bind -f "$INPUTRC"'
    'eval "$(zoxide init bash)"'
)

for line in "${lines[@]}"; do
    if ! grep -Fqx "$line" "$BASHRC"; then
        echo "$line" >> "$BASHRC"
        echo "Added: $line"
    fi
done

### Inputrc

if [[ ! -f "$BASH_DIR/inputrc" ]]; then
    cp "$BASH_DIR/inputrc" ~/.bash
    echo "Created: $BASH_DIR/inputrc"
fi

### Optional .config installation

if [[ "$CREATE_CONFIG" == true ]]; then
    CONFIG_SOURCE="$SCRIPT_DIR/../../../.config"

    if [[ ! -d "$CONFIG_SOURCE" ]]; then
        echo
        echo "Config directory not found:"
        echo "  $CONFIG_SOURCE" >&2
        exit 1
    fi

    mkdir -p "$CONFIG_DIR"

    cp -a "$CONFIG_SOURCE"/. "$CONFIG_DIR"/

    echo
    echo "Installed config files:"
    echo "  $CONFIG_SOURCE"
    echo "  -> $CONFIG_DIR"
fi

### Validate bashrc before finishing

if ! bash -n "$BASHRC"; then
    echo
    echo "Error: $BASHRC contains a Bash syntax error." >&2
    echo "The installer will not source it automatically." >&2
    exit 1
fi

### Done

echo
echo "Bash configuration updated:"
echo "  $BASHRC"

echo
echo "Bash syntax:"
echo "  OK"

echo
echo "Run this to activate the changes:"
echo "  source ~/.bashrc"

