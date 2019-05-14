#!/bin/bash

### Get CPU usage for the last 1 second (ALL 1 1 <--)
idle=`mpstat -P ALL 1 1 | awk '{print $NF}' | tail -n 4 | sed 's/,/./g'`
usage=\
`
for i in $idle
do
   echo "(100-$i+0.5)/1" | bc
done
`

### Print usage graphically, each square = 5%
i=0
for u in $usage
do
	times=`step=5; echo "$u/$step" | bc`
	printf "CPU${i}"
	printf ": %02d%% " "${u}"
	printf "|%-${times}s\n" | sed 's/ /■/g'
	i=$((i+1))
done 
