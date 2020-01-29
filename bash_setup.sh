#!/bin/bash

wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_aliases" -O ~/.bash_aliases
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_history" -O ~/.bash_history
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_shopt" -O ~/.bash_shopt
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_prompt" -O ~/.bash_prompt
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.inputrc" -O ~/.inputrc
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.gdbinit" -O ~/.gdbinit
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.gitconfig" -O ~/.gitconfig

for bash in {aliases,history,shopt,prompt}; do
	echo "[ -f ~/.bash_$bash ] && . ~/.bash_$bash" >> ~/.bashrc
done
# requirement: fzf package
if [ -f ~/.fzf.bash]; then
	echo "[ -f ~/.fzf.bash ] && source ~/.fzf.bash" >> ~/.bashrc
fi
