#!/bin/sh

# A base script is found in i3lock-color's repo:
# https://github.com/PandorasFox/i3lock-color/blob/master/lock.sh
B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#ffee35aa'  # default
E='#bbbbbb11'  # darker clear ish
T='#af627cbb'  # text
W='#880000bb'  # wrong
V='#ffa44f88'  # verifying

i3lock \
--insidevercolor=$B   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$E      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$B   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 1            \
--blur 10              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="$USER, %A %d/%m" \
--keylayout 2         \
\
--ring-width 6.0      \
--radius 140          \
--time-font "Roboto"  \
--timesize 41  \
--date-font "Roboto"  \
--datesize 19  \
--verif-font "Roboto"  \
--wrong-font "Roboto"  \
--layout-font "Roboto"  \
--layoutsize 15  \

# --veriftext="Drinking verification can..."
# --wrongtext="Nope!"
# --textsize=20
# --modsize=10
# --datefont=monofur
# etc

