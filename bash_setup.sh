#!/bin/bash

bash_dir=~/.bash
cp -r .bash ~

# TODO: make a function that wraps this grep -v -q command
# these scripts (little tools) should be added to PATH
if [ -d ~/.bash/scripts ]; then
    toadd="PATH=\${PATH}:~/.bash/scripts"
    grep -v -q "$toadd" ~/.bashrc && echo "# Add my common scripts to the PATH so I don't have spend time sourcing them" >> ~/.bashrc
    grep -v -q "$toadd" ~/.bashrc && echo $toadd >> ~/.bashrc
fi

# bash configs
for bash in {aliases,history_cfg,shopt,prompt}; do
	grep -v -q $bash_dir/.bash_$bash ~/.bashrc && echo "[ -f $bash_dir/bash_$bash ] && . $bash_dir/bash_$bash" >> ~/.bashrc
done

# requirement: fzf package
if [ -f $bash_dir/.fzf.bash ]; then
	grep -v -q $bash_dir/.fzf.bash ~/.bashrc && echo "[ -f $bash_dir/.fzf.bash ] && source $bash_dir/.fzf.bash" >> ~/.bashrc
fi

git_completion_command="[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash"
grep -v -q git-completion.bash ~/.bashrc && echo $git_completion_command >> ~/.bashrc

# bash prompt - needs powerline fonts and material icons though
OS_ICON=
ps1_string="PS1='\n\[\e[0;38;5;195m\]╭─\[\e[0;38;5;234m\]\[\e[0;38;5;50;48;5;234m\]$OS_ICON \[\e[0;38;5;195;48;5;234m\]\u\[\e[0;38;5;234;48;5;236m\]\[\e[0;38;5;195;48;5;236m\]:: \w\[\e[0;38;5;236;48;5;239m\]\[\e[0;38;5;195;48;5;239m\]: `git rev-parse --abbrev-ref HEAD 2>/dev/null`\[\e[0;38;5;239m\]\[\e[m\]\n\[\e[0;38;5;195m\]╰▻ \[\e[m\]'"
grep -v -q  ~/.bashrc && echo $ps1_string >> ~/.bashrc

# configs
cp -r ~/.config/* ~/.config

# nvim config
if [ `which nvim` ]; then
    mkdir -p ~/.config
    cp -r .config/nvim ~/.config
fi

# .local executables
makedir -p ~/.local/bin

# other configs
cp .gitconfig ~
cp .inputrc ~
cp .gdbinit ~
