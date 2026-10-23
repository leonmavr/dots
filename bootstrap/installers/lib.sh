#!/usr/bin/env bash

# Shared helpers for the bootstrap installers.
#
# Source this file from an installer:
#
#   SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
#   # shellcheck source=lib.sh
#   source "$SCRIPT_DIR/lib.sh"

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    echo 'lib.sh is meant to be sourced, not executed.' >&2
    exit 1
fi

set -euo pipefail

LIB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

VERSIONS_FILE="$LIB_DIR/versions.conf"

if [[ ! -f $VERSIONS_FILE ]]; then
    echo "Error: versions file not found: $VERSIONS_FILE" >&2
    exit 1
fi

# shellcheck source=versions.conf
source "$VERSIONS_FILE"

# Print the normalized machine architecture: amd64 or arm64.
detect_arch() {
    case "$(uname -m)" in
        x86_64 | amd64)
            printf 'amd64\n'
            ;;
        aarch64 | arm64)
            printf 'arm64\n'
            ;;
        *)
            return 1
            ;;
    esac
}

# Exit unless the machine architecture is one of the given values.
require_arch() {
    local current expected

    if ! current="$(detect_arch)"; then
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
    fi

    for expected in "$@"; do
        [[ $current == "$expected" ]] && return 0
    done

    echo "Unsupported architecture: $(uname -m)" >&2
    exit 1
}

# Exit unless every given command is available.
require_cmd() {
    local cmd

    for cmd in "$@"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Error: $cmd is required." >&2
            exit 1
        fi
    done
}

# Print the value of a pinned version from versions.conf.
pinned() {
    local name=$1
    local value=${!name:-}

    if [[ -z $value ]]; then
        echo "Error: $name is not set in $VERSIONS_FILE" >&2
        exit 1
    fi

    printf '%s\n' "$value"
}

# Download $1 into $2.
fetch() {
    curl -fsSL --retry 3 --retry-delay 2 --proto '=https' -o "$2" "$1"
}

# Create a temporary directory once and remove it on exit.
TMP_DIR=''

make_tmp_dir() {
    if [[ -n $TMP_DIR ]]; then
        return 0
    fi

    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "${TMP_DIR:-}"' EXIT
}

# Install a binary into BIN_DIR: install_bin <source> [name]
install_bin() {
    local src=$1
    local name=${2:-${1##*/}}

    mkdir -p "$BIN_DIR"
    install -m 755 "$src" "$BIN_DIR/$name"
}
