#!/bin/bash

############ Preparation ############
WIDTHHEIGHT=`xrandr | grep \* | awk '{print $1}'`
# split on x - see https://stackoverflow.com/a/10638555
SCR_HEIGHT=${WIDTHHEIGHT#*x}
SCR_WIDTH=${WIDTHHEIGHT%x*}

CAL_WIDTH=200
CAL_HEIGHT=200

POSY=`cat $POLYCONFIG | grep height | grep -o -P '\d'*`
if [ -z $POSY ]; then
	POSY=`cat ~/.config/polybar/config | grep height | grep -o -P '\d'*` 
fi
POSX=`echo $SCR_WIDTH/2-$CAL_WIDTH/2-30 | bc`


############ Handle input ############
case "$1" in
	--center) 
		yad --calendar --no-buttons --posx=$POSX --posy=$POSY\
		--undecorated --fixed --close-on-unfocus 2> /dev/null
		;;
	--right)
		;;
	*)
		yad --calendar --no-buttons --posx=$POSX --posy=$POSY\
		--undecorated --fixed --close-on-unfocus 2> /dev/null
		;;
esac
