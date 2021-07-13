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
up() {
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
# print the n-th column of the piped buffer
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

k() {
    kill -9 %$1
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

alias g=git

alias md='mkdir -p'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../..'
alias cd-='cd -'


### Videos
if [ ! -z `which ffmpeg` ]; then
    mp42gif() {
        #read cmd arguments
        while [[ $# -gt 0 ]]; do
            key="$1"
            case $key in
                -f|--from|-from)
                    arg_from="$2"
                    shift # past argument
                    shift # past value
                    ;;
                -t|--to|-to)
                    arg_to="$2"
                    shift
                    shift
                    ;;
                -r|--resolution|-res|--res)
                    arg_resolution="$2"
                    shift
                    shift
                    ;;
                -fps|--fps|--frames-per-second)
                    arg_fps="$2"
                    shift
                    shift
                    ;;
                *)
                    # this is the file to convert
                    arg_file_input="$1"
                    shift
                    ;;
            esac
        done
        echo $arg_file_input $arg_resolution $arg_from

        # default values
        [ ! -x $arg_to ] && to="-to $arg_to" || to=""
        [ ! -x $arg_from ] && from="-ss $arg_from" || from=""
        [ ! -x $arg_resolution ] && resolution="$arg_resolution" || resolution=480
        [ ! -x $arg_fps ] && fps="$arg_fps" || fps=10

        ffmpeg -i $arg_file_input $from $to -c:v copy -c:a copy /tmp/temp.mp4 -y
        ffmpeg -i /tmp/temp.mp4 -vf "fps=$fps,scale=$resolution:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 /tmp/output.gif -y
        echo "===== gif saved at /tmp/output.gif ====="
        rm /tmp/temp.mp4
    }

    web2mp4() {
        fname="$1"
        fname=${fname%%.*}
        ffmpeg -fflags +genpts -i ${fname}.webm -r 24 ${fname}.mp4
    }

    # $1: mp4 file to convert to images
    # $2: format; png or jpg (not dot)
    mp42img() {
        input="$1"
        format=$2
        # TODO: error checking
        if [ "$#" -eq 2 ]; then
            format=$2
        fi
        f=`basename $input`
        out_folder=${f%%.*}
        mkdir -p $out_folder
        fps=`ffprobe -v 0 -of csv=p=0 -select_streams v:0 -show_entries stream=r_frame_rate $input | bc`
        ffmpeg -i $input -vf fps=$fps $out_folder/frame_%05d.$format
        echo "===== $input converted to $format images at folder $out_folder ====="	
    }

    # $1: a formatted string describing the input images, e.g. frame_%05.png
    img2mp4() {
        input=$1
        out_file=`echo ${input%\%*}.mp4`
        ffmpeg -i $input -c:v libx264 -vf fps=30 -pix_fmt yuv420p $out_file
        echo "===== Converted frames to file $out_file ====="
    }
fi

which youtube-dl > /dev/null 2>&1 &&
	alias yt='youtube-dl --user-agent "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"'


### Dependant on installed software

# Credits: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
which fzf > /dev/null 2>&1 &&\
    alias fzf="find * | fzf --prompt 'All> '              --header 'CTRL-D: Directories / CTRL-F: Files'              --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)'              --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)' | xclip -i -sel clip"


# Usage: sxiv *png -o | collage-hor
# Requires: imagemagick
which convert > /dev/null 2>&1 &&\
	#####################################################################
	# Prerequisites: imagemagick
	# About: Concatenates images in a grid formation, creating a collage.
	#        It's a wrapper around imagemagick's `montage` command
	# Usage:
	#     collage i,j,k\;l,j ->
	#     +-+-+-+
	#     |i|j|k|
	#     +-+-+-+
	#     |l|m| |
	#     +-+-+-+
	#     See also the command line arguments
	#####################################################################
	collage() {
	    #read cmd arguments
	    while [[ $# -gt 0 ]]; do
		local key="$1"
		case $key in
		    -f|--format)
			# format of output file - png or jpg
			local arg_format="$2"
			shift
			shift
			;;
		    -p|-pad|--pad|--padding)
			# in pixels
			local arg_pad="$2"
			shift
			shift
			;;
		    -pc|--padding-color|--padding-colour)
			# colours can be specified e.g. as Green, green, or \#00ff00
			local arg_pad_col="$2"
			shift
			shift
			;;
		    -b|-bor|--border)
			# in pixels
			local arg_border="$2"
			shift
			shift
			;;
		    -bc|--border-color|--border-colour)
			local arg_border_col="$2"
			shift
			shift
			;;
		    -h|--height)
			# height of each image in the collage
			local arg_height="$2"
			shift
			shift
			;;
		    -w|--width)
			# width of each image in the collage
			local arg_width="$2"
			shift
			shift
			;;
		    -l|--label)
			# if nonzero, it will label each image as (a), (b),...
			[ ! -z "$2" ] && arg_label=1 | arg_label=0
			shift
			shift
			;;
		    *)
			# files to process
			# file11,...,file1m\;file21,...,file2n etc. (n<=m)
			local arg_files_input="$1"
			shift
			;;
		esac
	    done
	    # default values
	    [ -x $arg_format ] && arg_format=png
	    [ -x $arg_pad ] && arg_pad=5
	    [ -x $arg_pad_col ] && arg_pad_col=White
	    [ -x $arg_border ] && arg_border=0
	    [ -x $arg_border_col ] && arg_border_col=White
	    [ -x $arg_width ] && arg_width=300
	    local out_file=/tmp/collage.${arg_format}

	    n_rows=`echo $arg_files_input | tr -cd \; | wc -c`
	    n_rows=$[ $n_rows+1 ]
	    n_cols=`echo $arg_files_input | sed 's/\;.*//g' |tr -cd , | wc -c`
	    n_cols=$[ $n_cols+1 ]
	    local input_files=`echo $arg_files_input | sed 's/[,\;]/ /g'`
	    # add label to each image
	    #convert $f -extent 40 -gravity South -gravity South -pointsize 30 -annotate +0-10 "testtt" /tmp/test.png
	    #montage null: zebra.png -tile 1x1 -geometry +0+30 -gravity South out.png

	    montage -border $arg_border -bordercolor $arg_border_col\
		-geometry ${arg_width}x${arg_height}+${arg_pad}+${arg_pad}\
		-background $arg_pad_col\
		-tile ${n_cols}x${n_rows}\
		$input_files $out_file
	    echo "Collage done! Output written to `realpath $out_file`"
	}


# credits: laggardkernel @https://github.com/ranger/ranger/issues/1554#issuecomment-491650123
if [ ! -z `which ranger` ]; then
    function ranger {
            local IFS=$'\t\n'
            local tempfile="$(mktemp -t tmp.XXXXXX)"
            local ranger_cmd=(
                    command
                    ranger
                    --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
            )
            
            ${ranger_cmd[@]} "$@"
            if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
                    cd -- "$(cat "$tempfile")" || return
            fi
            command rm -f -- "$tempfile" 2>/dev/null
    }
fi

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
