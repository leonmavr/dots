#!/bin/sh

selected=`echo "6500 (default)
6000
5500
5000
4500
4200
4000
3800
3600
3400" | rofi -dmenu -p "screen temp" -location 1 -width 16 -lines 5 -font "Roboto Condensed 11" -yoffset 34 -xoffset 220`

temp=`echo $selected | grep -Eo [0-9]*`
#echo $temp

if [ ! -z $temp ]; then
	redshift -x
	sleep 1
	redshift -O $temp
fi
