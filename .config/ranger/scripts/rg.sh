#!/usr/bin/env bash

FILE="$1"

fzf --phony \
  --delimiter=: \
  --with-nth=1,2 \
  --bind "start:reload:rg -i -n --no-heading --color=never {q} \"$FILE\" || true" \
  --bind "change:reload:rg -i -n --no-heading --color=never {q} \"$FILE\" || true" \
  --preview '
    query={q}
    line={1}

    if [[ "$line" =~ ^[0-9]+$ && -n "$query" ]]; then

      # Number of lines actually available in the fzf preview window
      height=${FZF_PREVIEW_LINES:-40}

      # Keep at least a few lines around the selected line
      (( height < 5 )) && height=5

      half=$((height / 2))
      total=$(wc -l < "'"$FILE"'")

      # Put the selected line roughly in the middle
      start=$((line - half))
      end=$((start + height - 1))

      # Clamp to beginning of file
      if (( start < 1 )); then
        start=1
        end=$height
      fi

      # Clamp to end of file
      if (( end > total )); then
        end=$total
        start=$((total - height + 1))
        (( start < 1 )) && start=1
      fi

      sed -n "${start},${end}p" "'"$FILE"'" |
        rg -i --color=always --passthru "$query" |
        awk -v l="$line" -v s="$start" '"'"'
          {
            n = NR + s - 1

            if (n == l)
              printf "\033[1;31m> %s\033[0m\n", $0
            else
              printf "  %s\n", $0
          }
        '"'"'

    else
      cat "'"$FILE"'"
    fi
  ' \
  --preview-window='50%'
