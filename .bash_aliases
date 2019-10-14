#!/bin/bash

### Commands
ping() {
    if [[ $# -eq 0 ]] ; then
        command ping -c 4 8.8.8.8
    else
        command ping "$@"
    fi
}

find() {
    command find "$@" 2>&1 | grep -v "Permission denied"
}

findhere(){
    find . -name "$1" 2>&1 | grep -v "Permission denied"
}

grephere(){
	grep -rnw . -e "$1"
}

mdcd() {
    mkdir "$1" && cd "$1"
}

# credits https://serverfault.com/a/3842
extract () {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz) tar xvzf "$1" ;;
            *.tar.xz) tar xf "$1" ;;
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
fawk() {
    first="awk '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}

# source https://www.digitalocean.com/community/questions/what-are-your-favorite-bash-aliases
# Syntax: "repeat [X] [command]"
repeat()
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do # --> C-like syntax
        eval "$@";
    done
}

# cd always followed by ls
# credits @pyratebeard
# https://www.reddit.com/r/linux/comments/7oc5mt/what_are_some_useful_things_you_put_on_your/ds8q7yg?utm_source=share&utm_medium=web2x
cd() {
    builtin cd "$@" && ls -lAh
}


### Aliases

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
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias lll='ls -lhtr'
alias llla='ls -lhtrA'
# credits: piffey on reddit
alias lsmod="ls -la --color | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"
alias n='ls -la . | wc -l'

alias mex='chmod u+x'
alias mwr='chmod u+w'
alias py='python'

alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias svim='sudo vim'

alias md='mkdir'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../..'
alias cd-='cd -'
