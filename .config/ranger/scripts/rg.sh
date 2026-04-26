#!/usr/bin/env bash

FILE="$1"

fzf --ansi --phony \
  --bind "start:reload:rg -i --color=always --line-number {q} \"$FILE\" || true" \
  --bind "change:reload:rg -i --color=always --line-number {q} \"$FILE\" || true" \
  --preview "
    query={q}
    line=\$(echo {} | sed 's/\x1b\[[0-9;]*m//g' | cut -d: -f1)

    if [[ \"\$line\" =~ ^[0-9]+$ && -n \"\$query\" ]]; then
      total=\$(wc -l < \"$FILE\")
      height=40
      half=\$((height / 2))

      start=\$((line - half))
      end=\$((line + half))

      if (( start < 1 )); then
        start=1
        end=\$height
      fi

      if (( end > total )); then
        end=\$total
        start=\$((total - height + 1))
        (( start < 1 )) && start=1
      fi

      sed -n \"\${start},\${end}p\" \"$FILE\" \
        | rg -i --color=always --passthru \"\$query\" \
        | awk -v l=\"\$line\" -v s=\"\$start\" '
            {
              n = NR + s - 1
              if (n == l) {
                printf \"> %s\n\", \$0
              } else {
                print \"  \" \$0
              }
            }
          '
    else
      cat \"$FILE\"
    fi
  " \
  --preview-window=50%
