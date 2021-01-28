# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
    find . -iname "$1" 2>&1 | grep -v "Permission denied"
}

grephere(){
	grep -rnw . -e "$1"
}

mdcd() {
    mkdir -p "$1" && cd "$1"
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

nn() {
	cat "$1" | wc -l
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
alias cll='clear; ll'
alias clll='clear; lll'
alias cllla='clear; llla' 
# credits: piffey on reddit
alias lsmod="ls -lah --color | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\" %0o \",k);print}'"
# count files in directory (not hidden)
alias n='ls -l | grep ^- | wc -l'

alias mx='chmod u+x'
alias mwr='chmod u+w'
alias py='python3'

alias edit='vim'
alias vimrc='vim ~/.vimrc'
bashrc() { vim ~/.bashrc; source ~/.bashrc; }
alias .b='. ~/.bashrc'
alias svim='sudo vim'
alias v='vim'

alias md='mkdir -p'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../..'
alias cd-='cd -'

# videos
which ffmpeg > /dev/null 2>&1 &&
	mp42gif() { ffmpeg -i $1 -vf "fps=10,scale=720:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 /tmp/output.gif; }
which youtube-dl > /dev/null 2>&1 &&
	alias yt='youtube-dl --user-agent "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"'


### Dependant on installed software


which fzf > /dev/null 2>&1 && alias fzf='fzf | xargs realpath | tr -d "\n" | xclip -selection c -i'

# Usage: sxiv *png -o | collage-hor
# Requires: imagemagick
which convert > /dev/null 2>&1 &&\
	collage-hor() {
		tojoin=""
		while read frompipe; do
			tojoin="$tojoin `echo $frompipe | tr -d '\n'`";
		done
		convert $tojoin +append /tmp/collage.png
		xclip -selection clipboard -t image/png -i /tmp/collage.png
		pgrep dunst > /dev/null 2>&1 && dunstify -i /tmp/collage.png "Collage saved to /tmp/collage.png and copied to clipboard"
		#rm out_$$.png
	}

which convert > /dev/null 2>&1 &&\
	collage-ver() {
		tojoin=""
		while read frompipe; do
			tojoin="$tojoin `echo $frompipe | tr -d '\n'`";
		done
		convert $tojoin -append /tmp/collage.png
		xclip -selection clipboard -t image/png -i /tmp/collage.png
		pgrep dunst > /dev/null 2>&1 && dunstify -i /tmp/collage.png "Collage saved to /tmp/collage.png and copied to clipboard"
		#rm out_$$.png
	}
	
which ranger > /dev/null 2>&1 &&\
	alias r='ranger'


which curl > /dev/null 2>&1 &&\
which jq > /dev/null 2>&1 &&\
	btc-price() {
		curl -s https://api.coinbase.com/v2/prices/spot?currency=USD |\
			jq '.data.amount' |\
			sed -E 's/(,\"*)//' |\
			xargs printf "$%.2f\n";
	}


### Key bindings
# Key bindings that couldn't go into .input rc
bind '"\C-F":"fzf\n"'
