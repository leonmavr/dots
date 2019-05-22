#!/bin/bash


######################################
# select message based on current day
######################################
sec=`date +%s`
day=`echo $sec/3600/24 | bc`
RAND=$day
N_MSG=`cat ../quotes.json | jq '.quotes | length'`

RAND_PER_DAY=`RANDOM=$day;echo $RANDOM`

rand_ind=`echo "$RAND_PER_DAY%$N_MSG" | bc`
# TODO: decide a path!
out_to_conky=`cat ../quotes.json | jq ".quotes[$rand_ind].message" | tr -d '"'`
echo `cat ../quotes.json | jq ".quotes[$rand_ind].message"`

# good so far
 sed -i "/scroll/c\${goto 45}\${voffset -26}QoD:\${scroll 47 12 $out_to_conky}" ~/.config/conky/conkylua
