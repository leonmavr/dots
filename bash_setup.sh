#!/bin/bash

wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_aliases" -O ~/.bash_aliases
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_history_cfg" -O ~/.bash_history_cfg
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_shopt" -O ~/.bash_shopt
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_prompt" -O ~/.bash_prompt
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.inputrc" -O ~/.inputrc
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.gdbinit" -O ~/.gdbinit
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.gitconfig" -O ~/.gitconfig
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.fzf.bash" -O ~/.fzf.bash

for bash in {aliases,history_cfg,shopt,prompt}; do
	grep -v -q .bash_$bash ~/.bashrc && echo "[ -f ~/.bash_$bash ] && . ~/.bash_$bash" >> ~/.bashrc
done

# requirement: fzf package
if [ -f ~/.fzf.bash ]; then
	grep -v -q .fzf.bash ~/.bashrc && echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc
fi
