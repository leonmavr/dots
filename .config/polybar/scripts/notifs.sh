#!/bin/sh

n_reminders=`remind ~/.config/remind/reminders.rem | sed '/^\s*$/d' | sed -n '2,9999 p' |  wc -l`
echo $n_reminders
if [ $n_reminders -gt 0 ]; then
	rem=`remind ~/.config/remind/reminders.rem`
	rem_edited=`printf "$rem" | sed '/^\s*$/d'`
	yad --text "$rem_edited" --no-buttons --posx=650 --posy=30 --undecorated --fixed --close-on-unfocus > /dev/null
fi
