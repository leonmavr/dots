#!/bin/sh


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
selected=`timedatectl list-timezones\
 | rofi -i -dmenu -p "timezone"\
	-location 2\
	-width 23\
	-lines 10\
	-font "Roboto Condensed 11"\
	-yoffset 34`


passwrd=`echo ""\
 | rofi -i -dmenu -p "enter password"\
	-location 2\
	-width 23\
	-lines 1\
	-font "Roboto Condensed 11"\
	-yoffset 34`

echo "$passwrd" | sudo -S timedatectl set-timezone $selected
unset passwrd

#stty -echo
#send_user -- "Password for $user@$host: "
#expect_user -re "(.*)\n"
#send_user "\n"
#stty echo
#set pass $expect_out(1,string)
#
##... later
#send -- "$pass\r"
