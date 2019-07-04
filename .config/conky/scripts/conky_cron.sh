#!/bin/bash

# Make sure cron service starts on login. Then do
# crontab -e
# 0 */3 * * * /home/$USER/.config/conky/scripts/conky_cron.
export DISPLAY=:0
touch /tmp/cron.txt
killall conky
/home/first/.config/conky/scripts/write_quotes.sh
conky -c ~/.config/conky/conkylua &
