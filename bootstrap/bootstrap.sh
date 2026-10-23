#!/usr/bin/env bash

# One-command bootstrap for the dotfiles.
#
#   curl -fsSL https://raw.githubusercontent.com/leonmavr/dots/master/bootstrap/bootstrap.sh | bash
#   curl -fsSL .../bootstrap.sh | bash -s -- --all --yes
#
# The repository is cloned into DOTS_DIR (or updated if it already exists),
# then the interactive installer takes over.
#
# Environment:
#   DOTS_REPO          git URL (default: https://github.com/leonmavr/dots.git)
#   DOTS_DIR           checkout location (default: ~/.local/share/dots)
#   DOTS_REF           branch, tag, or commit to check out
#   DOTS_SKIP_UPDATE=1 use the existing checkout without fetching

set -euo pipefail

REPO_URL="${DOTS_REPO:-https://github.com/leonmavr/dots.git}"
DOTS_DIR="${DOTS_DIR:-$HOME/.local/share/dots}"
DOTS_REF="${DOTS_REF:-}"

command -v git >/dev/null 2>&1 || {
    echo 'Error: git is required to bootstrap the dotfiles.' >&2
    exit 1
}

if [[ ${DOTS_SKIP_UPDATE:-0} != 1 ]]; then
    if [[ -d $DOTS_DIR/.git ]]; then
        echo "Updating $DOTS_DIR..."

        if [[ -n $DOTS_REF ]]; then
            git -C "$DOTS_DIR" fetch --depth 1 --quiet origin "$DOTS_REF"
        else
            git -C "$DOTS_DIR" fetch --depth 1 --quiet origin
        fi

        git -C "$DOTS_DIR" reset --hard --quiet FETCH_HEAD
    elif [[ -e $DOTS_DIR ]]; then
        echo "Error: $DOTS_DIR exists but is not a git checkout." >&2
        exit 1
    else
        echo "Cloning $REPO_URL into $DOTS_DIR..."
        mkdir -p "$(dirname -- "$DOTS_DIR")"

        if [[ -n $DOTS_REF ]]; then
            git clone --depth 1 --branch "$DOTS_REF" "$REPO_URL" "$DOTS_DIR"
        else
            git clone --depth 1 "$REPO_URL" "$DOTS_DIR"
        fi
    fi
fi

INSTALLER="$DOTS_DIR/bootstrap/installers/install.sh"

if [[ ! -f $INSTALLER ]]; then
    echo "Error: installer not found: $INSTALLER" >&2
    exit 1
fi

# When this script is piped into bash, stdin is the pipe, not the terminal.
# The installer needs a TTY for its UI, so reconnect it when one is available.
if [[ ! -t 0 ]] && (exec </dev/tty) 2>/dev/null; then
    exec bash "$INSTALLER" "$@" </dev/tty
fi

exec bash "$INSTALLER" "$@"
