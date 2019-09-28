#!/bin/sh

SPACES="      "
selected=`echo "${SPACES}Shut down
${SPACES}Reboot
${SPACES}Lock
${SPACES}Log off" | rofi -dmenu -p "" -location 3 -width 14 -lines 4 -hide-scrollbar -font "Roboto Condensed 11" -yoffset 34 -xoffset -4`

if [[ $selected == *[S\|s]hut* ]]; then
	shutdown -h now
elif [[ $selected == *[R\|r]eboot* ]]; then
	reboot
elif [[ $selected == *[L\|l]ock* ]]; then
	~/.config/i3lock-color/lock.sh &&\
		sleep 3 &&\
		xset dpms force off
elif [[ $selected == *[L\|l]og* ]]; then
	logout
fi
