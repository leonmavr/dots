#!/bin/bash

### Purpose
# Install local Bash configuration, fzf config, Git/GDB config,
# and repository .config contents.
#
# Options:
#   --no-config-copy    Do not copy repository .config contents into ~/.config

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BASHRC="$HOME/.bashrc"
BASH_DIR="$HOME/.bash"
CONFIG_DIR="$HOME/.config"

FZF_CONFIG_SOURCE="$SCRIPT_DIR/../../../.bash/.fzf.bash"
FZF_CONFIG_DEST="$BASH_DIR/.fzf.bash"

INPUTRC_SOURCE="$SCRIPT_DIR/../../../.bash/inputrc"
INPUTRC_DEST="$BASH_DIR/inputrc"

COPY_CONFIG=true

# True when a command is available now or was just installed into ~/.local/bin.
has_command() {
    local name=$1

    command -v "$name" >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/$name" ]]
}

### Parse arguments

case "${1:-}" in
    "")
        ;;
    --no-config-copy)
        COPY_CONFIG=false
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Usage: $0 [--no-config-copy]" >&2
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

### Git / GDB config

GIT_CFG="$SCRIPT_DIR/../../../.gitconfig"
GIT_COMPLETION="$SCRIPT_DIR/../../../.git-completion.bash"
GDBINIT="$SCRIPT_DIR/../../../.gdbinit"

if [[ -f "$GIT_CFG" ]]; then
    install -m 644 "$GIT_CFG" "$HOME/.gitconfig"
    echo "Copied git config:"
    echo "  $HOME/.gitconfig"
else
    echo "Git config not found:"
    echo "  $GIT_CFG"
fi

if [[ -f "$GIT_COMPLETION" ]]; then
    install -m 644 "$GIT_COMPLETION" "$HOME/.git-completion.bash"
    echo "Copied git completion:"
    echo "  $HOME/.git-completion.bash"
else
    echo "Git completion not found:"
    echo "  $GIT_COMPLETION"
fi

if [[ -f "$GDBINIT" ]]; then
    install -m 644 "$GDBINIT" "$HOME/.gdbinit"
    echo "Copied GDB config:"
    echo "  $HOME/.gdbinit"
else
    echo "GDB config not found:"
    echo "  $GDBINIT"
fi

# Prefer git-delta for diff if installed
if [[ -x "$HOME/.local/bin/delta" ]]; then
    git config --global core.pager delta
    echo "Configured Git to use delta as pager"
else
    echo "git-delta not installed; skipping Git delta configuration"
fi

### Bash configuration

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

# Remove old versions of lines managed by this installer.
#
# IMPORTANT:
# Only remove complete configuration lines. Do not touch surrounding
# if/then/fi blocks from the system .bashrc.
#
# Both the historical "." form and the "source" form are removed.

sed -i \
    -e '/^[[:space:]]*eval "\$(fzf --bash)"[[:space:]]*$/d' \
    -e '/^[[:space:]]*eval "\$(command fzf --bash)"[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/\.fzf\.bash[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/\.fzf\.bash[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/\.fzf\.bash[[:space:]]*\][[:space:]]*&&[[:space:]]*\.[[:space:]]*~\/\.bash\/\.fzf\.bash[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_aliases[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_aliases[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_aliases[[:space:]]*\][[:space:]]*&&[[:space:]]*\.[[:space:]]*~\/\.bash\/bash_aliases[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_prompt[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_prompt[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_prompt[[:space:]]*\][[:space:]]*&&[[:space:]]*\.[[:space:]]*~\/\.bash\/bash_prompt[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_history_cfg[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_history_cfg[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_history_cfg[[:space:]]*\][[:space:]]*&&[[:space:]]*\.[[:space:]]*~\/\.bash\/bash_history_cfg[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_shopt[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.bash\/bash_shopt[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.bash\/bash_shopt[[:space:]]*\][[:space:]]*&&[[:space:]]*\.[[:space:]]*~\/\.bash\/bash_shopt[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.git-completion\.bash[[:space:]]*\][[:space:]]*&&[[:space:]]*source[[:space:]]*~\/\.git-completion\.bash[[:space:]]*$/d' \
    -e '/^[[:space:]]*\[[[:space:]]*-f[[:space:]]*~\/\.git-completion\.bash[[:space:]]*\][[:space:]]*&&[[:space:]]*\.[[:space:]]*~\/\.git-completion\.bash[[:space:]]*$/d' \
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
#
# fzf and zoxide hooks are only added when those tools are installed,
# so a minimal machine does not get a broken ~/.bashrc.

lines=(
    'export PATH="$HOME/.local/bin:$PATH"'
    'export PATH="$HOME/.bash/scripts:$PATH"'
    '[ -f ~/.bash/.fzf.bash ] && source ~/.bash/.fzf.bash'
    '[ -f ~/.bash/bash_aliases ] && source ~/.bash/bash_aliases'
    '[ -f ~/.bash/bash_prompt ] && source ~/.bash/bash_prompt'
    '[ -f ~/.bash/bash_history_cfg ] && source ~/.bash/bash_history_cfg'
    '[ -f ~/.bash/bash_shopt ] && source ~/.bash/bash_shopt'
    '[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash'
    'export INPUTRC="$HOME/.bash/inputrc"'
    'bind -f "$INPUTRC"'
)

if has_command fzf; then
    lines+=('eval "$(command fzf --bash)"')
fi

if has_command zoxide; then
    lines+=('eval "$(zoxide init bash)"')
fi

for line in "${lines[@]}"; do
    if ! grep -Fqx "$line" "$BASHRC"; then
        echo "$line" >> "$BASHRC"
        echo "Added: $line"
    fi
done

### Inputrc

if [[ ! -f "$INPUTRC_SOURCE" ]]; then
    echo "inputrc not found:"
    echo "  $INPUTRC_SOURCE" >&2
    exit 1
fi

if [[ ! -f "$INPUTRC_DEST" ]]; then
    install -m 644 "$INPUTRC_SOURCE" "$INPUTRC_DEST"
    echo "Created: $INPUTRC_DEST"
fi

### .config installation

if [[ "$COPY_CONFIG" == true ]]; then
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
else
    echo
    echo "Skipping .config installation (--no-config-copy)"
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
