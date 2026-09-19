#!/bin/bash

# one argument and integer
if [ $# -eq 1 ] && [[ $1 =~ ^-?[0-9]+$ ]]; then
	redshift -O $1
else
	redshift -O 3300 
fi
