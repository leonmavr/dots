#!/bin/bash

# disable <C-q>, <C-s> mainly for ViM
setxkbmap -option caps:escape
feh --bg-scale ~/Pictures/wallpapers/553818.jpg

exec i3
