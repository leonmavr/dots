#!/bin/sh

selected=`echo "Shut down
Reboot
Lock
Sleep" | rofi -dmenu -p "" -theme purple -location 3 -width 15  -separator-style none -hide-scrollbar -font "Roboto Condensed 11" -lines 4 -yoffset 34`

if [[ $selected == *[S\|s]hut* ]]; then
	poweroff
elif [[ $selected == *[R\|r]eboot* ]]; then
	reboot
elif [[ $selected == *[L\|l]ock* ]]; then
	~/.config/i3lock-color/lock.sh &&\
		sleep 10 &&\
		xset dpms force off
elif [[ $selected == *[S\|s]leep* ]]; then
	xset dpms force off
fi
