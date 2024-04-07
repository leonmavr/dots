#!/usr/bin/env bash

# map caps lock to escape
setxkbmap -option caps:escape
#feh --bg-scale ~/Pictures/wallpapers/23493284932842384.jpg
# switch layout with shift+alt
setxkbmap -option grp:alt_shift_toggle gb,gr

exec i3
