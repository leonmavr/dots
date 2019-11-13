#!/bin/sh

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
n_ws=`i3-msg -t get_workspaces | jq '. | length'`
# icon width depends on polybar config - find out what it is
ws_icon_width=26
ws_width_total=$[ 165+$ws_icon_width*$n_ws ]

current_val=`cat /tmp/redshift_val`
[ -z $current_val ] && current_val=then_i_will_not_grep_this_value


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
selected=`echo "6500
6000
5500
5000
4500
4200
4000
3800
3600
3400
3200
3000" | sed -s "s/$current_val/$current_val   ●/g" | rofi -dmenu -p "screen temp"\
	-location 1\
	-width 16\
	-lines 5\
	-font "Roboto Condensed 11"\
	-yoffset 34\
	-xoffset $ws_width_total`

temp=`echo $selected | grep -Eo [0-9]*`

if [ ! -z $temp ]; then
	redshift -x
	sleep 1
	redshift -O $temp
	echo $temp > /tmp/redshift_val
fi
