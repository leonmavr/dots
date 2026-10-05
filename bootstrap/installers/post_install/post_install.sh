#!/bin/bash

### Purpose
# Point bashrc to a copy of the config in this repo

set -euo pipefail

BASHRC="$HOME/.bashrc"
BASH_DIR="$HOME/.bash"

if [[ ! -f "$BASHRC" ]]; then
    touch "$BASHRC"
fi

mkdir -p "$BASH_DIR"

# Lines to add to ~/.bashrc.
lines=(
    'eval "$(fzf --bash)"'
    '[ -f ~/.bash/bash_aliases ] && source ~/.bash/bash_aliases'
    '[ -f ~/.bash/bash_prompt ] && source ~/.bash/bash_prompt'
    '[ -f ~/.bash/bash_history_cfg ] && source ~/.bash/bash_history_cfg'
    '[ -f ~/.bash/bash_shopt ] && source ~/.bash/bash_shopt'
    'export INPUTRC="$HOME/.bash/inputrc"'
    'eval "$(zoxide init bash)"'
    'export PATH="$HOME/.local/bin:$PATH"'
)

for line in "${lines[@]}"; do
    if ! grep -Fqx "$line" "$BASHRC"; then
        echo "$line" >> "$BASHRC"
        echo "Added: $line"
    fi
done

# Create inputrc if it doesn't exist.
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

