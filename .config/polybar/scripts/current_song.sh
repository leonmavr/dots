#!/bin/sh

title=`mpc -f %title% | head -1`
artist=`mpc -f %artist% | head -1`
album=`mpc -f %album% | head -1`
year=`mpc -f %date% | head -1 | grep -Eo '[0-9]{4}'`

if [ ! -z `pgrep mpd` ]; then
	yad --text "♪ Currently playing:\n    $title\n    $artist\n    $album\n    $year"\
		--no-buttons\
		--posx=250\
		--posy=36\
		--undecorated\
		--fixed\
		--close-on-unfocus\
		--timeout 10\
		2>/dev/null
fi
