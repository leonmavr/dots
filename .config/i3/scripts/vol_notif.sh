#!/bin/sh
###
# Brief: This is meant to be run by i3
#        every time a volume key is pressed
###


###Requirements
which dunst > /dev/null 2>&1 || exit 1 
which pulseaudio > /dev/null 2>&1 || exit 1 


### Functionality
function get_volume {
	pactl list sinks\
		| grep Volume:\
		| awk '{print $5}'\
		| sed 's/%//g'\
		|head -1 2> /dev/null
}

function is_mute {
	[ `pactl list sinks | grep Mute: | awk '{print $2}'` == "yes" ] && echo "yes" || echo "no"
}

# based on https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
function send_notif {
	vol=`get_volume` 
	muted=`is_mute`
	# my keybinds increment volume every 5% up to 150% so
	bar=`seq -s "━" $[ ${vol}/5 ] | sed 's/[0-9]//g'`
	if [ $vol -le 40 ]; then
		icon=audio-volume-low
	elif [ $vol -le 90 ]; then
		icon=audio-volume-medium
	elif [ $vol -gt 90 ]; then
		icon=audio-volume-high
	fi
	if [ $muted == yes ]; then
		icon=audio-volume-muted
	fi
	# timeout (-t) in ms, -r is the ID
	dunstify -i $icon -t 300 -r 13337 -u low " $bar"
}


### Main 
send_notif
