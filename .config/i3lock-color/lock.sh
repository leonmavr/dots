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
--insidever-color=$B     \
--ringver-color=$V     \
\
--insidewrong-color=$C \
--ringwrong-color=$W   \
\
--inside-color=$E      \
--ring-color=$D        \
--line-color=$B        \
--separator-color=$B   \
\
--verif-color=$T        \
--wrong-color=$T        \
--time-color=$T        \
--date-color=$T        \
--layout-color=$T      \
--keyhl-color=$W       \
--bshl-color=$W        \
\
--screen 1            \
--blur 10              \
--clock               \
--indicator           \
--time-str="%H:%M"  \
--date-str="$USER, %A %d/%m" \
--keylayout 2         \
\
--ring-width 6.0      \
--radius 140          \
--time-font "Roboto"  \
--time-size 41  \
--date-font "Roboto"  \
--date-size 19  \
--verif-font "Roboto"  \
--wrong-font "Roboto"  \
--layout-font "Roboto"  \
--layout-size 15 \
\
--verif-text="FBI, $USER is in!" \
--wrong-text="Nope!"
# --textsize=20
# --modsize=10
# --datefont=monofur
# etc
