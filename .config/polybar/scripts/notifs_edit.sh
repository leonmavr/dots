#!/bin/bash

### Adapted from:
### https://unix.stackexchange.com/a/474300
mkdir -p ~/.config/remind
cd ~/.config/remind
termite -e 'vim reminders.rem' &
pid="$!"


# Wait for the window to open and grab its window ID
winid=''
while : ; do
    winid="`wmctrl -lp | awk -vpid=$pid '$3==pid {print $1; exit}'`"
    [[ -z "${winid}" ]] || break
done

# Focus the window we found
wmctrl -ia "${winid}"

# Make it float
i3-msg floating enable > /dev/null;

# Move it to the center for good measure
i3-msg move position center > /dev/null;

# Wait for the application to quit
wait "${pid}";
