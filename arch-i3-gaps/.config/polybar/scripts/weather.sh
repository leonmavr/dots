#!/bin/bash

# Adapted from x70b1's script, credits to him
#        🗲

# 0 = failure, 1 = success
PING=0
API="https://api.openweathermap.org/data/2.5"
API_KEY=b8f2d720c34a57fd69ad75e7efd4ed35
KEY=$API_KEY
COUNTRY=$2
CITY=$1
DATA_FILE=/tmp/weather.js


get_icon(){
	if [[ $1 == *[C\|c]lear* ]]; then
		icon=
	elif [[ $1 == *[c\|C]loud* ]]; then
		icon=" "
	elif [[ $1 == *[r\|R]*ain ]]; then
		icon=
	elif [[ $1 == *[d\|D]*rizzle ]]; then
		icon=
	elif [[ $1 == *[f\|F]og* ]]; then 
		icon=
	elif [[ $1 == *[m\|M]ist* ]]; then 
		icon=
	elif [[ $1 == *[s\|S]now* ]]; then
		icon=
	elif [[ $1 == *[s\|S]torm* ]]; then
		icon=🗲
	elif [[ $1 == *[s\|S]and* ]]; then
		icon=SAND
	else
		icon=?
	fi
}



case "$1" in
	--more)
		dbus-launch notify-send 'detailed report under construction!' &	
		;;
esac


get_location(){
	## TODO: this is not very accurate, find a better way
	# api.openweathermap.org/data/2.5/weather?lat=35&lon=139
	# api.openweathermap.org/data/2.5/weather?q=London,uk

	if [[ -z $CITY ]] || [[ -z $COUNTRY ]]; then

		location=`curl -sf https://location.services.mozilla.com/v1/geolocate?key=geoclue`
		if [ -n "$location" ]; then
			location_lat="$(echo "$location" | jq '.location.lat')"
			location_lon="$(echo "$location" | jq '.location.lng')"
			wget -q "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS" -O $DATA_FILE 
		fi
	else
		wget -q "$API/weather?appid=$KEY&q=$CITY,$COUNTRY" -O $DATA_FILE 
	fi
}

process_data() {
	temp=`cat $DATA_FILE | jq '.main.temp'`
	temp2cels=`echo $temp-273.15 | bc`
	temp2int=`printf "%.0f" $temp2cels` 
	descr=`cat $DATA_FILE | jq '.weather[0].main' | sed 's/"//g'`
	location=`cat $DATA_FILE | jq '.name' | sed 's/"//g'`
	# stores result in icon var
	get_icon $descr
	msg="$location, $temp2int°C, $descr$icon"
	echo $msg
	#yad --text "$msg" --no-buttons --undercorated --close-on-unfocus --posx 710 --posy 27 --width=300 
}

get_location
process_data
