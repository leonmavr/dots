#!/bin/bash


######################################
# select message based on current day
######################################
function get_author(){
	first_name=`cat ~/.config/conky/quotes.json | jq ".quotes[$rand_ind].firstName" | tr -d '"'`	
	last_name=`cat ~/.config/conky/quotes.json | jq ".quotes[$rand_ind].lastName" | tr -d '"'`	
	full_name=""
	if [ -z $last_name ]; then
		full_name="$first_name"
	elif [ -z $first_name ]; then
		full_name="$last_name"
	elif [[ $first_name == [S\|s]aint ]]; then
		first_name=St.
		full_name="$first_name $last_name"
	else
		first_name=`echo $first_name | cut -c1-1`
		full_name="$first_name. $last_name"
	fi
	echo $full_name
}

sec=`date +%s`
day=`echo $sec/3600/24 | bc`
RAND=$day
N_MSG=`cat ~/.config/conky/quotes.json | jq '.quotes | length'`

RAND_PER_DAY=`RANDOM=$day;echo $RANDOM`

rand_ind=`echo "$RAND_PER_DAY%$N_MSG" | bc`
out_to_conky=`cat ~/.config/conky/quotes.json | jq ".quotes[$rand_ind].message" | tr -d '"'`
#echo `cat ~/.config/conky/quotes.json | jq ".quotes[$rand_ind].message"`

# Refresh quote - author at `author_name`
get_author
sed -i "/scroll/c\${goto 45}\${voffset -26}QoD: \${font ProFont for Powerline:size=12}\${scroll 47 14 $out_to_conky - $full_name}" ~/.config/conky/conkylua
