#!/bin/bash

bash_dir=~/.bash
mkdir $bash_dir
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_aliases" -O $bash_dir/.bash_aliases
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_history_cfg" -O $bash_dir/.bash_history_cfg
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_shopt" -O $bash_dir/.bash_shopt
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.bash_prompt" -O $bash_dir/.bash_prompt
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.inputrc" -O $bash_dir/.inputrc
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.gdbinit" -O $bash_dir/.gdbinit
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.gitconfig" -O $bash_dir/.gitconfig
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.fzf.bash" -O $bash_dir/.fzf.bash

for bash in {aliases,history_cfg,shopt,prompt}; do
	grep -v -q $bash_dir/.bash_$bash ~/.bashrc && echo "[ -f $bash_dir/.bash_$bash ] && . $bash_dir/.bash_$bash" >> ~/.bashrc
done

# requirement: fzf package
if [ -f $bash_dir/.fzf.bash ]; then
	grep -v -q $bash_dir/.fzf.bash ~/.bashrc && echo "[ -f $bash_dir/.fzf.bash ] && source $bash_dir/.fzf.bash" >> ~/.bashrc
fi
