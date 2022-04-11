#!/bin/bash

### Requirements:
# xclip
# imagemagick
# scrot
# dunst (optional)


# Take screenshot of an area and save to clipboard
sshot() {
    rm -f /tmp/screenshot.png
    local prefix=$2
    local postfix=$3
    local sshot_file=/tmp/${prefix}screenshot${postfix}.png
    if [[ "$1" == *"full"* ]]; then
        scrot $sshot_file
    else
        import ${sshot_file}
    fi
    xclip -selection clipboard -t image/png -i ${sshot_file}
    which dunst && dunstify -u low -i $sshot_file "screenshot to clipboard"
}

sshot $@
