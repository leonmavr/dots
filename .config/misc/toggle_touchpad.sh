#!/bin/bash

current=`synclient -l | grep TouchpadOff | grep -Eo [0-9]`
if [ $current -eq 0 ]; then
	synclient TouchpadOff=1
else
	synclient TouchpadOff=0
fi
