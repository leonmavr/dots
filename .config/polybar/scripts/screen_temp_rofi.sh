#!/bin/sh

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
n_ws=`i3-msg -t get_workspaces | jq '. | length'`
# icon width depends on polybar config - find out what it is
ws_icon_width=26
ws_width_total=$[ 165+$ws_icon_width*$n_ws ]

if [ $# -eq 1 ]; then
	current_val=$1
	if [ $current_val -eq 6500 ]; then
		echo 6500 > /tmp/redshift_val
		redshift -x
		kill $$
	fi
else
	current_val=`cat /tmp/redshift_val`
fi
[ -z "$current_val" ] && current_val=6500 && echo 6500 > /tmp/redshift_val


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
selected=`echo "6500    ○
6000    ○
5500    ○
5000    ○
4500    ○
4250    ○
4000    ○
3750    ○
3500    ○
3250    ○
3000    ○"\
	| sed -s "s/${current_val}.*/${current_val}    ●/g" | rofi -dmenu -p "screen temp"\
	-location 1\
	-width 16\
	-lines 5\
	-font "Roboto Condensed 11"\
	-yoffset 34\
	-xoffset $ws_width_total`

# clear the Unicode decoration
selected=`echo $selected | grep -Eo [0-9]+`
echo $selected > /tmp/dbg_sel

if [ ! -z $selected ]; then
	redshift -x
	sleep 1
	redshift -O $selected
	echo $selected > /tmp/redshift_val
fi
