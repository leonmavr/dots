#!/bin/sh

_copy_to_clip() {
	echo "$@" | tr -d '\n' | xclip -selection clipboard
	[ ! -z "$@" ] && which dunst && \
		dunstify "$1 copied to clipboard." -i /tmp/i_dont_exist.png -t 1000 -u low
}

_emoji_csv_file=`python3 ~/.bash/scripts/rofi_emojis/emojipedia_dl.py`
selected=`cat $_emoji_csv_file\
	| rofi -dmenu -p "" -location 3 -width 40 -lines 10 -hide-scrollbar  -columns 2 -font "Roboto Condensed 11" -yoffset 34 -xoffset -4`

emoji=`echo $selected | awk -F':' '{print $1}'`

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
