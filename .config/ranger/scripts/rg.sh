#!/usr/bin/env bash

FILE="$1"

fzf --ansi --phony --query "" \
  --bind "start:reload:rg -i --color=always --line-number {q} \"$FILE\" || true" \
  --bind "change:reload:rg -i --color=always --line-number {q} \"$FILE\" || true" \
  --preview "rg -i --color=always --context 5 {q} \"$FILE\" || cat \"$FILE\""
