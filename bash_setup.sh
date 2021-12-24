#!/bin/bash

bash_dir=~/.bash
mkdir -p $bash_dir
mkdir -p ~/.bash/scripts
cp -r .bash ~

if [ -d ~/.bash/scripts ]; then
    toadd="PATH=\${PATH}:~/.bash/scripts"
    grep -v -q "$toadd" ~/.bashrc && echo "# Add my common scripts to the PATH so I don't have spend time sourcing them" >> ~/.bashrc
    grep -v -q "$toadd" ~/.bashrc && echo $toadd >> ~/.bashrc
fi

for bash in {aliases,history_cfg,shopt,prompt}; do
	grep -v -q $bash_dir/.bash_$bash ~/.bashrc && echo "[ -f $bash_dir/.bash_$bash ] && . $bash_dir/.bash_$bash" >> ~/.bashrc
done

# requirement: fzf package
if [ -f $bash_dir/.fzf.bash ]; then
	grep -v -q $bash_dir/.fzf.bash ~/.bashrc && echo "[ -f $bash_dir/.fzf.bash ] && source $bash_dir/.fzf.bash" >> ~/.bashrc
fi
