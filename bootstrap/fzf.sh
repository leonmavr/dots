#!/bin/bash

### Purpose
# Locally (at ~/.local/bin) install fzf

set -e

version=0.74.4
arch="$(uname -m)"

case "$arch" in
  x86_64)  asset="linux_amd64" ;;
  aarch64) asset="linux_arm64" ;;
  *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
esac

mkdir -p ~/.local/bin
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fsSL \
  "https://github.com/junegunn/fzf/releases/download/v${version}/fzf-${version}-${asset}.tar.gz" \
  -o "$tmp/fzf.tar.gz"

tar -xzf "$tmp/fzf.tar.gz" -C "$tmp"
install -m 755 "$tmp/fzf" ~/.local/bin/fzf

~/.local/bin/fzf --version

