#!/bin/sh

if [ "$#" -eq 0 ]; then
	echo -e "Usage:\n./<this_script> <colon_separated_file>"
	echo -e "The color-separated file must contain an emoji on the left field of each line and its description on the right."
	exit 0
fi

[ ! -f "$1" ] && python3 ~/.config/i3/scripts/get_emojis.py "$1" 

selected=`cat "$1"\
| rofi -dmenu -p "" -location 3 -width 20 -lines 10 -hide-scrollbar -font "Roboto Condensed 11" -yoffset 34 -xoffset -4`

emoji=`echo $selected | awk -F':' '{print $1}'`
echo $emoji | tr -d '\n' | xclip -selection clipboard
