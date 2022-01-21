#!/bin/sh

_copy_to_clip() {
	echo "$@" | tr -d '\n' | xclip -selection clipboard
	[ ! -z "$@" ] && which dunst && \
		dunstify "$1 copied to clipboard." -i /tmp/i_dont_exist.png -t 1000 -u low
}


if [ "$#" -eq 0 ]; then
	echo -e "Usage:\n./<this_script> <colon_separated_file>"
	echo -e "The color-separated file must contain an emoji on the left field of each line and its description on the right."
	exit 0
fi

[ ! -f "$1" ] && python3 ~/.config/i3/scripts/get_emojis.py "$1" 

selected=`cat "$1"\
	| rofi -dmenu -p "" -location 3 -width 20 -lines 10 -hide-scrollbar -font "Roboto Condensed 11" -yoffset 34 -xoffset -4`

emoji=`echo $selected | awk -F':' '{print $1}'`
# either copy emojis or go to menu for lenny faces
if [ [ $selected != *"lenny"* ] && [ $selected != *"kawaii"* ] ]; then
    _copy_to_clip "$emoji" 
fi

if [[ $selected == *"lenny"* ]]; then
	lenny_file="/home/$USER/.config/i3/scripts/lenny_faces.csv"
	selected=`cat "$lenny_file"\
		| rofi -dmenu -p "" -location 3 -width -40 -lines 10 -hide-scrollbar -font "Roboto Condensed 11" -yoffset 34 -xoffset -4`
elif [[ $selected == *"kawaii"* ]]; then
	kawaii_file="/home/$USER/.config/i3/scripts/kawaii.csv"
	selected=`cat "$kawaii_file"\
		| rofi -dmenu -p "" -location 3 -width -40 -lines 10 -hide-scrollbar -font "Roboto Condensed 11" -yoffset 34 -xoffset -4`
fi

emoji=`echo $selected | awk -F':' '{print $1}'`
_copy_to_clip "$emoji"
