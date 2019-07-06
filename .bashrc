# @file: .bashrc
# @author: 0xleo
# @OS: Arch


################################################
# Config files
################################################
export I3CONFIG=~/.config/i3/config
#export I3STATUS=~/.config/i3status/config
export TERMITECONFIG=~/.config/termite/config
export COMPTONCONFIG=~/.compton
export GTKCONFIG=~/.gtkrc-2.0
export RANGERCONFIG=~/.config/ranger/rc.conf
export CONKYCONFIG=~/.config/conky/conky.conf
export GTKCSS=~/.config/gtk-3.0/gtk.css
export POLYCONFIG=~/.config/polybar/config
#export I3BLOCKSCONFIG=~/.config/i3blocks/config
export SXIVKEYS=~/.config/sxiv/exec/key-handler
export CONKYQUOTES=~/.config/conky/quotes.json
export SYNCLIENTCONF=/usr/lib/X11/xorg.conf.d/10-synaptics.conf
export I3LOCKCONFIG=~/.config/i3lock-color/lock.sh
# needs `remind` package
export REMINDERS=~/.config/remind/reminders.rem
export FILECRON=/var/spool/cron/$USER


################################################
# Default apps
################################################
if [ -z "$TERM" ]; then
	export TERM=termite
fi
export PAGER=/usr/bin/more
export EDITOR=`which vim`


################################################
# General behaviour 
################################################
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
case $- in
	*i*) ;;
	*) return;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

###### History is the best documentation ######
# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
# Append to history instead of overwrite
shopt -s histappend
# show date and time in history
export HISTTIMEFORMAT='(%d/%m, %H:%M) '
# Multiple commands on one line show up as a single line
shopt -s cmdhist
# supress anything by adding space in front of the command
# don't save one or two-letter commands, etc
export HISTIGNORE="ls*:ll*:pwd:exit:clear:history:\
		[ \t]*:?:??:[bf]g:*compton*"
# search history with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# keymaps don't work:
stty -ixon

# autocomplete only dirs
complete -d cd

# cd always followed by ls
# credits @pyratebeard
# https://www.reddit.com/r/linux/comments/7oc5mt/what_are_some_useful_things_you_put_on_your/ds8q7yg?utm_source=share&utm_medium=web2x
cd() {
	builtin cd "$@" && ls -lA
}

# Make sure env variables in prompt get expanded
shopt -s promptvars 
# custom PS1
export PS1='\[\033[38;5;197m\]⌌ \[$(tput bold)\][\u@\h:${PWD#"${PWD%/*/*}/"}] :$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\n⌎ \[$(tput sgr0)\]\[$(tput sgr0)\]'
# open programs that require windows
export DISPLAY=:0

# toggle betwen a short(1 char) and a full PS1 - 40 just empirical
function ps1(){
	if [ ${#PS1} -gt 40 ]; then
		export PS1="\[$(tput bold)\]\[\033[38;5;197m\] \[$(tput sgr0)\]"
		clear
	else
		export PS1='\[\033[38;5;197m\]⌌ \[$(tput bold)\][\u@\h:${PWD#"${PWD%/*/*}/"}] :$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\n⌎ \[$(tput sgr0)\]\[$(tput sgr0)\]'
	fi
}

# needs `thefuck` https://github.com/nvbn/thefuck
# correct mistyped commands by typing one of the following
if [ ! -z `which thefuck` ]; then
	eval $(thefuck --alias)
	eval $(thefuck --alias shit)
	eval $(thefuck --alias frick)
	eval $(thefuck --alias omg)
	eval $(thefuck --alias lolno)
fi

################################################
# New commands/ overwrite system commands 
################################################
function ping() {
	if [[ $# -eq 0 ]] ; then
		command ping -c 4 8.8.8.8
	else
		command ping "$@"
	fi
}

function find() {
	command find "$@" 2>&1 | grep -v "Permission denied"
}

function findhere(){
	find . -name "$1" 2>&1 | grep -v "Permission denied"
}

function mdcd() {
	mkdir $1 && cd $1
}

# credits https://serverfault.com/a/3842
extract () {
	if [ -f "$1" ] ; then
		case "$1" in
			*.tar.bz2) tar xvjf "$1" ;;
			*.tar.gz) tar xvzf "$1" ;;
			*.bz2) bunzip2 "$1" ;;
			*.rar) unrar x "$1" ;;
			*.gz) gunzip "$1" ;;
			*.tar) tar xvf "$1" ;;
			*.tbz2) tar xvjf "$1" ;;
			*.tgz) tar xvzf "$1" ;;
			*.zip) unzip "$1" ;;
			*.Z) uncompress "$1" ;;
			*.7z) 7z x "$1" ;;
			*) echo "don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

# credits https://serverfault.com/a/28649
up(){
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
	do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# credits https://serverfault.com/a/5551
function fawk {
	first="awk '{print "
	last="}'"
	cmd="${first}\$${1}${last}"
	eval $cmd
}

# Get IPs associated with this site
# Work to dynamically list all interfaces. Will add later.
# Currently only uses the hardcoded interface names
# source https://www.digitalocean.com/community/questions/what-are-your-favorite-bash-aliases
# TODO: fix 
function myip()
{
	extIp=$(dig +short myip.opendns.com @resolver1.opendns.com)

	printf "Wireless IP: "
	MY_IP=$(/sbin/ifconfig wlp3s0 | awk '/inet/ { print $2 } ' |
	sed -e s/addr://)
	echo ${MY_IP:-"Not connected"}


	printf "Wired IP: "
	MY_IP=$(/sbin/ifconfig enp0s25 | awk '/inet/ { print $2 } ' |
		sed -e s/addr://)
	echo ${MY_IP:-"Not connected"}

	echo ""
	echo "WAN IP: $extIp"
}

# source https://www.digitalocean.com/community/questions/what-are-your-favorite-bash-aliases
# Syntax: "repeat [X] [command]"
function repeat()
{
	local i max
	max=$1; shift;
	for ((i=1; i <= max ; i++)); do # --> C-like syntax
		eval "$@";
	done
}


################################################
# My aliases
################################################
alias h='history'

# coloured commands                             
if [ -x /usr/bin/dircolors ]; then
	alias ls='ls --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
	alias grep='grep -I --color=auto'
	alias diff='diff --color'
else
    alias grep='grep -I'
fi

# silent gdb
alias gdb='gdb -q'

# list files
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lltr='ls -lhtr'

alias pacman='sudo pacman'
# for the next 2 commands, see sudoers - they don't need pwd!
alias wifi-radar='sudo wifi-radar'
alias wifi-menu='sudo wifi-menu'

alias mex='chmod u+x'
alias mwr='chmod u+w'
alias bat-level='cat /sys/class/power_supply/BAT0/capacity'
alias py='python'
# e.g. timezone Europe/Berlin
alias timezone='timedatectl set-timezone'

alias open-conky='conky -c ~/.config/conky/conky.conf'
alias restart-polybar='killall polybar;polybar top&'
alias restart-compton='killall compton;compton -b --config $COMPTONCONFIG'
# from cronie package
alias start-cron='systemctl start cronie'

alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'

alias record-screen="ffmpeg -video_size `xrandr | grep *+ | awk '{print $1}'` -framerate 30 -f x11grab -i :0.0+0,0 /tmp/output.mp4"

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../..'

if [ ! -z /usr/bin/remind ]; then
	alias remind-get-month='remind -c1 ~/.config/remind/reminders.rem'
	alias remind-get='remind ~/.config/remind/reminders.rem'
	alias remind-edit='vim ~/.config/remind/reminders.rem'
fi


## correct time
# timedatectl set-ntp true
## send notification
# dbus-launch notify-send "Hello"
## calendar
# yad --calendar

# to query openweathermaps API - get a key from their website
OPENWEATHERAPIKEY=XXXXXXXXXXXXXXXXXXXXXXX
