#!/bin/bash

setxkbmap -option caps:escape
synclient PalmDetect=1
feh --bg-scale /home/first/Pictures/wallpapers/133062.jpg

exec i3
