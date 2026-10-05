#!/bin/bash

### Purpose
# Install local Bash configuration and fzf config.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BASHRC="$HOME/.bashrc"
BASH_DIR="$HOME/.bash"

FZF_CONFIG_SOURCE="$SCRIPT_DIR/../../../.bash/.fzf.bash"
FZF_CONFIG_DEST="$BASH_DIR/.fzf.bash"

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

### bashrc configuration

lines=(
    'export PATH="$HOME/.local/bin:$PATH"'
    'eval "$(fzf --bash)"'
    '[ -f ~/.bash/.fzf.bash ] && source ~/.bash/.fzf.bash'
    '[ -f ~/.bash/bash_aliases ] && source ~/.bash/bash_aliases'
    '[ -f ~/.bash/bash_prompt ] && source ~/.bash/bash_prompt'
    '[ -f ~/.bash/bash_history_cfg ] && source ~/.bash/bash_history_cfg'
    '[ -f ~/.bash/bash_shopt ] && source ~/.bash/bash_shopt'
    'export INPUTRC="$HOME/.bash/inputrc"'
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
    touch "$BASH_DIR/inputrc"
    echo "Created: $BASH_DIR/inputrc"
fi

echo
echo "Bash configuration updated:"
echo "  $BASHRC"

echo
echo "Run this to activate the changes:"
echo "  source ~/.bashrc"

