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
 sed -i "/scroll/c\${scroll 25 5 $out_to_conky}" ~/.config/conky/conky.conf
