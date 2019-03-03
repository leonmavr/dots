################################################
# ~/.bashrc
###############################################
# edit i3-related files and configs
export I3CONFIG=~/.config/i3/config
export I3STATUS=~/.config/i3status/config
export TERMITECONFIG=~/.config/termite/config
export COMPTONCONFIG=~/.compton
export GTKCONFIG=~/.gtkrc-2.0
export RANGERCONFIG=~/.config/ranger/rc.conf
export CONKYCONFIG=~/.config/conky/conky.conf

# Terminal
export TERM=termite

# Default apps
export EDITOR=/usr/bin/vim
export PAGER=/usr/bin/more

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
 
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
 
 
# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
 
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
 
 
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
 
 
alias h='history'
# search history with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# autocomplete only dirs
complete -d cd
 

# coloured commands                             
if [ -x /usr/bin/dircolors ]; then
     alias ls='ls --color=auto'
     alias fgrep='fgrep --color=auto'
     alias egrep='egrep --color=auto'
     alias grep='grep --color=auto'
fi


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# needs `thefuck` https://github.com/nvbn/thefuck
eval $(thefuck --alias)
eval $(thefuck --alias shit)

# browse filesystem via ncmpcpp
#export MPD_HOST=$HOME/.config/mpd/socket
# custom PS1
export PS1="\[$(tput bold)\]\[\033[38;5;33m\]\u\[$(tput bold)\]\[\033[38;5;33m\]@\[$(tput bold)\]\[\033[38;5;33m\]\h\[$(tput sgr0)\]\[\033[38;5;45m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;39m\]\W\\$ \[$(tput sgr0)\]"

# open programs that require windows
export DISPLAY=:0


# open conky
alias open-conky='conky -c ~/.config/conky/conky.conf'
alias sshot='scrot' # e.g. scrot -t 20 -d 5
